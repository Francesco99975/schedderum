import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:schedderum/helpers/uuid.dart';
import 'package:schedderum/models/display_record.dart';
import 'package:schedderum/providers/clipboardx.dart';
import 'package:schedderum/providers/records.dart';
import 'package:schedderum/providers/week_context_provider.dart';
import 'package:schedderum/util/snackbar_service.dart';
import 'package:schedderum/widget/add_new_record.dart';
import 'package:schedderum/widget/employee_record_item.dart';

class DayRecordCard extends ConsumerWidget {
  final DateTime date;
  final List<DisplayRecord> records;
  final void Function(DisplayRecord) onRecordDismissed;
  final String currentDepartmentId;

  const DayRecordCard({
    super.key,
    required this.date,
    required this.records,
    required this.onRecordDismissed,
    required this.currentDepartmentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = DateFormat.d().format(date); // e.g. 21
    final weekday = DateFormat.E().format(date); // e.g. Mon

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Side: Date
            Container(
              width: 64,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder:
                        (_) => AddRecordModal(
                          date: date,
                          day: day,
                          weekday: weekday,
                          departmentId: currentDepartmentId,
                        ),
                  );
                },
                onLongPress: () {
                  final weekStart = startOfWeek(date);
                  final weekEnd = endOfWeek(weekStart);
                  final clip = ref.watch(clipboardxProvider);
                  clip.maybeMemoDisplayRecord.match(
                    () {
                      SnackBarService.showNegativeSnackBar(
                        context: context,
                        message: "No record to copy",
                      );
                    },
                    (dr) async {
                      final result = await ref
                          .read(
                            recordsProvider(
                              currentDepartmentId,
                              weekStart,
                              weekEnd,
                            ).notifier,
                          )
                          .addRecord(
                            dr.record
                                .copyWith(
                                  id: uuid(),
                                  start: DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    dr.record.start.hour,
                                    dr.record.start.minute,
                                  ),
                                  end: DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    dr.record.end.hour,
                                    dr.record.end.minute,
                                  ),
                                )
                                .toDbModel(dr.employeeId),
                            currentDepartmentId,
                            weekStart,
                            weekEnd,
                          );

                      result.match(
                        (l) => SnackBarService.showNegativeSnackBar(
                          context: context,
                          message: "Failed to paste record: ${l.message}",
                        ),
                        (r) => SnackBarService.showPositiveSnackBar(
                          context: context,
                          message: "Record pasted from clipboard to $day",
                        ),
                      );
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      weekday.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Side: Records
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children:
                      records
                          .map(
                            (r) => EmployeeRecordItem(
                              displayRecord: r,
                              onDismissed: (_) => onRecordDismissed(r),
                              date: date,
                              currentDepartmentId: currentDepartmentId,
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
