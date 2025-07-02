import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/models/department.dart';
import 'package:schedderum/models/display_record.dart';
import 'package:schedderum/providers/records.dart';
import 'package:schedderum/providers/week_context_provider.dart';
import 'package:schedderum/widget/async_provider_wrapper.dart';
import 'package:schedderum/widget/day_record_card.dart';

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
  @override
  Widget build(BuildContext context) {
    final weekStart = widget.weekStart;
    final weekEnd = endOfWeek(weekStart);

    final List<DateTime> weekDays = [];

    for (int i = 0; i < 7; i++) {
      weekDays.add(weekStart.add(Duration(days: i)));
    }

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
        return Scaffold(
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      //Filtering DROPDOWN
                      //PDF BTN
                      //CSV BTN
                    ],
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: weekDays.length,
                  itemBuilder:
                      (context, index) => DayRecordCard(
                        date: weekDays[index],
                        currentDepartmentId: widget.currentDepartment.id,
                        records:
                            records
                                .where(
                                  (r) => r.record.start.eqvYearMonthDay(
                                    weekDays[index],
                                  ),
                                )
                                .toList(),
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
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
