import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:schedderum/models/display_record.dart';
import 'package:schedderum/models/record.dart';
import 'package:schedderum/providers/clipboardx.dart';
import 'package:schedderum/providers/settings_provider.dart';
import 'package:schedderum/util/formatters.dart';
import 'package:schedderum/util/responsive.dart';
import 'package:schedderum/util/snackbar_service.dart';
import 'package:schedderum/widget/update_record.dart';

class EmployeeRecordItem extends ConsumerWidget {
  final DisplayRecord displayRecord;
  final Function onDismissed;
  final DateTime date;
  final String currentDepartmentId;

  const EmployeeRecordItem({
    super.key,
    required this.displayRecord,
    required this.onDismissed,
    required this.date,
    required this.currentDepartmentId,
  });

  String _formatDuration(Duration duration) {
    double hours = duration.inMinutes / 60.0;
    if (hours == hours.roundToDouble()) {
      return "${hours.toInt()}H";
    }
    return "${hours.toStringAsFixed(1)}H";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTimeFormatter = ref.watch(activeDateFormatterProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final duration = displayRecord.record.duration;
    final borderColor =
        displayRecord.record.type == RecordType.SHIFT
            ? Colors.lightBlueAccent
            : displayRecord.record.type == RecordType.SICK
            ? Colors.red
            : displayRecord.record.type == RecordType.VACATION
            ? Colors.amber
            : Colors.grey.shade300;

    return Dismissible(
      key: ValueKey(displayRecord.record.id),
      direction: DismissDirection.startToEnd, // left to right
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onDismissed(direction);
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          return await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: Text(
                    "Are you sure ?",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  content: Text(
                    "Do you want to remove this record?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "No",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.red),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text(
                        "Yes",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.green),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
          );
        }
        return false;
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: ListTile(
          onTap: () async {
            await showDialog(
              context: context,
              builder:
                  (_) => UpdateRecordModal(
                    date: date,
                    displayRecord: displayRecord,
                    departmentId: currentDepartmentId,
                  ),
            );
          },
          onLongPress: () {
            ref
                .read(clipboardxProvider.notifier)
                .copyDisplayRecord(displayRecord);
            SnackBarService.showPositiveSnackBar(
              context: context,
              message: "Record Copied to clipboard",
            );
          },
          leading: settingsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => const Icon(Icons.error),
            data:
                (settings) => CircleAvatar(
                  backgroundColor: Color(displayRecord.employeeColor),
                  child:
                      displayRecord.record.type == RecordType.SHIFT
                          ? Text(
                            _formatDuration(
                              regulatedDuration(
                                duration,
                                settings.breakFrequencyHours,
                                settings.breakDurationHours,
                              ),
                            ),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: getContrastingTextColor(
                                Color(displayRecord.employeeColor),
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : displayRecord.record.type == RecordType.SICK
                          ? Icon(
                            Icons.health_and_safety,
                            color: getContrastingTextColor(
                              Color(displayRecord.employeeColor),
                            ),
                          )
                          : displayRecord.record.type == RecordType.VACATION
                          ? Icon(
                            Icons.work,
                            color: getContrastingTextColor(
                              Color(displayRecord.employeeColor),
                            ),
                          )
                          : displayRecord.record.type == RecordType.UNAVAILABLE
                          ? Icon(
                            Icons.block,
                            color: getContrastingTextColor(
                              Color(displayRecord.employeeColor),
                            ),
                          )
                          : displayRecord.record.type == RecordType.TIME_OFF
                          ? Icon(
                            Icons.chair,
                            color: getContrastingTextColor(
                              Color(displayRecord.employeeColor),
                            ),
                          )
                          : Icon(
                            Icons.person,
                            color: getContrastingTextColor(
                              Color(displayRecord.employeeColor),
                            ),
                          ),
                ),
          ),
          title: Text(
            displayRecord.employeeFullName,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            _determineRecordType(
              displayRecord.record.type,
              activeTimeFormatter,
              displayRecord.record.isAllDay(),
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
          ),
          trailing: IconButton(
            onPressed: () {
              ref
                  .read(clipboardxProvider.notifier)
                  .copyShift(
                    displayRecord.record.start,
                    displayRecord.record.end,
                  );
              SnackBarService.showPositiveSnackBar(
                context: context,
                message: "Shift Copied to clipboard",
              );
            },
            icon: const Icon(Icons.copy_all, color: Colors.lightGreenAccent),
          ),
        ),
      ),
    );
  }

  String _determineRecordType(
    RecordType type,
    DateFormat activeTimeFormatter,
    bool allDay,
  ) {
    switch (type) {
      case RecordType.SHIFT:
        return "${activeTimeFormatter.format(displayRecord.record.start)} - ${activeTimeFormatter.format(displayRecord.record.end)}";
      case RecordType.SICK:
        return "Sick";
      case RecordType.UNAVAILABLE:
        if (allDay) {
          return "Unavailable";
        } else {
          return "Unavailable from: ${activeTimeFormatter.format(displayRecord.record.start)} to: ${activeTimeFormatter.format(displayRecord.record.end)}";
        }
      case RecordType.VACATION:
        return "Vacation";
      case RecordType.TIME_OFF:
        return "Time Off";
    }
  }
}
