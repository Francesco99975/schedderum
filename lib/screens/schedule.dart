import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:schedderum/models/department.dart';
import 'package:schedderum/models/display_record.dart';
import 'package:schedderum/models/record.dart';
import 'package:schedderum/providers/records.dart';
import 'package:schedderum/providers/settings_provider.dart';
import 'package:schedderum/providers/week_context_provider.dart';
import 'package:schedderum/screens/add_extensive_records_form.dart';
import 'package:schedderum/util/generation.dart';
import 'package:schedderum/util/snackbar_service.dart';
import 'package:schedderum/widget/async_provider_wrapper.dart';
import 'package:schedderum/widget/day_record_card.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showLoadingDialog(
  BuildContext context, {
  String message = "Please wait...",
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (_) => PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}

class ScheduleScreen extends ConsumerStatefulWidget {
  final Department currentDepartment;
  final DateTime weekStart;

  const ScheduleScreen({
    super.key,
    required this.currentDepartment,
    required this.weekStart,
  });

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final Set<RecordType> selectedTypes = {
    RecordType.SHIFT,
    RecordType.SICK,
    RecordType.UNAVAILABLE,
    RecordType.VACATION,
    RecordType.TIME_OFF,
  };

  final _fabKey = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    final activeTimeFormatter = ref.watch(activeDateFormatterProvider);
    final weekStart = widget.weekStart;
    final weekEnd = endOfWeek(weekStart);
    final settingsAsync = ref.watch(settingsProvider);

    final List<DateTime> weekDays = [
      for (int i = 0; i < 7; i++) weekStart.add(Duration(days: i)),
    ];

    return AsyncProviderWrapper<List<DisplayRecord>>(
      provider: recordsProvider(
        widget.currentDepartment.id,
        weekStart,
        weekEnd,
      ),
      future:
          recordsProvider(
            widget.currentDepartment.id,
            weekStart,
            weekEnd,
          ).future,
      render: (records) {
        final filtered = records.where(
          (r) => selectedTypes.contains(r.record.type),
        );

        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PopupMenuButton<RecordType>(
                      icon: const Icon(Icons.filter_list),
                      itemBuilder:
                          (_) =>
                              RecordType.values.map((type) {
                                return PopupMenuItem<RecordType>(
                                  value: type,
                                  child: StatefulBuilder(
                                    builder: (context, setStatePopup) {
                                      final isSelected = selectedTypes.contains(
                                        type,
                                      );
                                      return CheckboxListTile(
                                        value: isSelected,
                                        onChanged: (v) {
                                          setState(() {
                                            if (v == true) {
                                              selectedTypes.add(type);
                                            } else {
                                              selectedTypes.remove(type);
                                            }
                                          });
                                          setStatePopup(
                                            () {},
                                          ); // Update inside popup
                                        },
                                        title: Text(type.name),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: weekDays.length,
                  itemBuilder: (context, index) {
                    final date = weekDays[index];
                    final dayRecords =
                        filtered
                            .where((r) => r.record.start.eqvYearMonthDay(date))
                            .toList();

                    return DayRecordCard(
                      date: date,
                      currentDepartmentId: widget.currentDepartment.id,
                      records: dayRecords,
                      onRecordDismissed: (r) {
                        ref
                            .read(
                              recordsProvider(
                                widget.currentDepartment.id,
                                weekStart,
                                weekEnd,
                              ).notifier,
                            )
                            .removeRecord(
                              r.record.toDbModel(r.employeeId),
                              widget.currentDepartment.id,
                              weekStart,
                              weekEnd,
                            );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: settingsAsync.when(
            data:
                (settings) => ExpandableFab(
                  key: _fabKey,
                  overlayStyle: ExpandableFabOverlayStyle(
                    color: Colors.black.withValues(alpha: 0.5),
                    blur: 3,
                  ),
                  openButtonBuilder: RotateFloatingActionButtonBuilder(
                    child: const Icon(Icons.add),
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: const CircleBorder(),
                  ),
                  closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                    child: const Icon(Icons.close),
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: const CircleBorder(),
                  ),
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'add',
                      tooltip: 'Add record',
                      child: const Icon(Icons.person_add),
                      onPressed: () {
                        _fabKey.currentState?.toggle();
                        context.push(
                          "${AddExtensiveRecordFormScreen.routePath}?departmentId=${widget.currentDepartment.id}",
                        );
                      },
                    ),
                    FloatingActionButton.small(
                      heroTag: 'pdf',
                      tooltip: 'Export to PDF',
                      backgroundColor: Colors.redAccent,
                      child: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        _fabKey.currentState?.toggle();
                        showLoadingDialog(context);

                        final path = await generateSchedulePdf(
                          currentDepartment: widget.currentDepartment,
                          weekStart: weekStart,
                          weekEnd: weekEnd,
                          displayRecords:
                              records
                                  .where(
                                    (r) => r.record.type == RecordType.SHIFT,
                                  )
                                  .toList(),
                          weekDays: weekDays,
                          timeFormatter: activeTimeFormatter,
                          maxHours: settings.maxHours,
                          bfh: settings.breakFrequencyHours,
                          bdh: settings.breakDurationHours,
                        );

                        if (!Platform.isLinux) {
                          final shareParams = ShareParams(
                            files: [
                              XFile(
                                path,
                                mimeType: 'application/pdf',
                                name: path.split('/').last,
                              ),
                            ],
                          );

                          final result = await SharePlus.instance.share(
                            shareParams,
                          );

                          if (!context.mounted) return;
                          Navigator.of(context, rootNavigator: true).pop();

                          if (result.status == ShareResultStatus.success) {
                            SnackBarService.showPositiveSnackBar(
                              context: context,
                              message: "PDF exported successfully",
                            );
                          }
                        } else {
                          if (!context.mounted) return;
                          Navigator.of(context, rootNavigator: true).pop();
                          SnackBarService.showPositiveSnackBar(
                            context: context,
                            message: "PDF exported successfully on $path",
                          );
                        }
                      },
                    ),
                    FloatingActionButton.small(
                      heroTag: 'csv',
                      tooltip: 'Export to CSV',
                      backgroundColor: Colors.greenAccent,
                      child: const Icon(
                        Icons.file_copy_sharp,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        _fabKey.currentState?.toggle();
                        showLoadingDialog(context);

                        final path = await generateScheduleCsv(
                          currentDepartment: widget.currentDepartment,
                          weekStart: weekStart,
                          weekEnd: weekEnd,
                          displayRecords:
                              records
                                  .where(
                                    (r) => r.record.type == RecordType.SHIFT,
                                  )
                                  .toList(),
                          weekDays: weekDays,
                          timeFormatter: activeTimeFormatter,
                          maxHours: settings.maxHours,
                          bfh: settings.breakFrequencyHours,
                          bdh: settings.breakDurationHours,
                        );

                        if (!Platform.isLinux) {
                          final shareParams = ShareParams(
                            files: [
                              XFile(
                                path,
                                mimeType: 'text/csv',
                                name: path.split('/').last,
                              ),
                            ],
                          );

                          final result = await SharePlus.instance.share(
                            shareParams,
                          );

                          if (!context.mounted) return;
                          Navigator.of(context, rootNavigator: true).pop();

                          if (result.status == ShareResultStatus.success) {
                            SnackBarService.showPositiveSnackBar(
                              context: context,
                              message: "CSV exported successfully",
                            );
                          }
                        } else {
                          if (!context.mounted) return;
                          Navigator.of(context, rootNavigator: true).pop();
                          SnackBarService.showPositiveSnackBar(
                            context: context,
                            message: "CSV exported successfully on $path",
                          );
                        }
                      },
                    ),
                  ],
                ),
            error: (_, _) => null,
            loading: () => null,
          ),
        );
      },
    );
  }
}
