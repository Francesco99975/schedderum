import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/models/display_record.dart';
import 'package:schedderum/models/employee.dart';
import 'package:schedderum/models/record.dart';
import 'package:schedderum/providers/employees.dart';
import 'package:schedderum/providers/records.dart';
import 'package:schedderum/providers/week_context_provider.dart';
import 'package:schedderum/util/snackbar_service.dart';

class UpdateRecordModal extends ConsumerStatefulWidget {
  final String selectedEmployeeId;
  final DisplayRecord displayRecord;
  final DateTime date;
  final String departmentId;

  const UpdateRecordModal({
    super.key,
    required this.selectedEmployeeId,
    required this.displayRecord,
    required this.date,
    required this.departmentId,
  });

  @override
  ConsumerState<UpdateRecordModal> createState() => _UpdateRecordModalState();
}

class _UpdateRecordModalState extends ConsumerState<UpdateRecordModal> {
  Employee? selectedEmployee;
  late RecordType selectedType;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isAllDay = false;

  @override
  void initState() {
    super.initState();
    final rec = widget.displayRecord.record;
    selectedType = rec.type;
    isAllDay =
        selectedType == RecordType.SICK ||
        (rec.start.hour == 0 && rec.end.hour == 23);
    startTime = TimeOfDay.fromDateTime(rec.start);
    endTime = TimeOfDay.fromDateTime(rec.end);
  }

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          isStart
              ? (startTime ?? TimeOfDay(hour: 9, minute: 0))
              : (endTime ?? TimeOfDay(hour: 17, minute: 0)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              hourMinuteTextStyle: TextStyle(fontSize: 40), // Adjust font size
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ), // Add padding
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        isStart ? startTime = picked : endTime = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (selectedEmployee == null ||
        (selectedType == RecordType.SHIFT &&
            (startTime == null || endTime == null))) {
      SnackBarService.showNegativeSnackBar(
        context: context,
        message: "Please fill out all fields",
      );
      return;
    }

    final isTimed = selectedType == RecordType.SHIFT || !isAllDay;
    final date = widget.date;
    final newStart = DateTime(
      date.year,
      date.month,
      date.day,
      isTimed ? startTime!.hour : 0,
      isTimed ? startTime!.minute : 0,
    );
    final newEnd = DateTime(
      date.year,
      date.month,
      date.day,
      isTimed ? endTime!.hour : 23,
      isTimed ? endTime!.minute : 59,
    );

    if (newStart.isAfter(newEnd)) {
      SnackBarService.showNegativeSnackBar(
        context: context,
        message: "Start must come before end",
      );
      return;
    }

    final updatedDbRecord = widget.displayRecord.record
        .toDbModel(selectedEmployee!.id)
        .copyWith(start: newStart, end: newEnd, type: selectedType.name);

    final weekStart = startOfWeek(date);
    final weekEnd = endOfWeek(weekStart);

    final result = await ref
        .read(recordsProvider(widget.departmentId, weekStart, weekEnd).notifier)
        .updateRecord(updatedDbRecord, widget.departmentId, weekStart, weekEnd);

    result.match(
      (l) => SnackBarService.showNegativeSnackBar(
        context: context,
        message: "Failed to update: ${l.message}",
      ),
      (_) => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(
      employeesByDepartmentProvider(widget.departmentId),
    );

    return AlertDialog(
      title: const Text("Update Record"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          employeesAsync.when(
            loading:
                () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
            error: (e, _) => Text('Error: $e'),
            data:
                (either) => either.match(
                  (failure) => Text("Error: ${failure.message}"),
                  (employees) {
                    selectedEmployee ??=
                        employees
                            .where(
                              (e) => e.id == widget.displayRecord.employeeId,
                            )
                            .first;
                    return DropdownButtonFormField<Employee>(
                      value: selectedEmployee,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "Select Employee",
                        border: OutlineInputBorder(),
                      ),
                      items:
                          employees
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.getFullName()),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => setState(() {
                            selectedEmployee = value;
                          }),
                    );
                  },
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children:
                RecordType.values
                    .where(
                      (t) =>
                          t == RecordType.SHIFT ||
                          t == RecordType.SICK ||
                          t == RecordType.UNAVAILABLE,
                    )
                    .map(
                      (type) => ChoiceChip(
                        label: Text(type.name),
                        selected: selectedType == type,
                        onSelected: (_) {
                          setState(() {
                            selectedType = type;
                            if (type == RecordType.SICK) {
                              isAllDay = true;
                            } else if (type == RecordType.SHIFT) {
                              isAllDay = false;
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 12),
          if (selectedType == RecordType.UNAVAILABLE)
            SwitchListTile.adaptive(
              title: const Text("All Day"),
              value: isAllDay,
              onChanged: (v) => setState(() => isAllDay = v),
            ),
          if (selectedType == RecordType.SHIFT || !isAllDay)
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    icon: const Icon(Icons.schedule),
                    label: Text(
                      startTime != null ? startTime!.format(context) : "Start",
                    ),
                    onPressed: () => _pickTime(context, true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    icon: const Icon(Icons.schedule),
                    label: Text(
                      endTime != null ? endTime!.format(context) : "End",
                    ),
                    onPressed: () => _pickTime(context, false),
                  ),
                ),
              ],
            ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.check),
          label: const Text("Update"),
        ),
      ],
    );
  }
}
