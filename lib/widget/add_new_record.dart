import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/database/database.dart' as db;
import 'package:schedderum/helpers/uuid.dart';
import 'package:schedderum/models/employee.dart';
import 'package:schedderum/models/record.dart';
import 'package:schedderum/providers/employees.dart';
import 'package:schedderum/providers/records.dart';
import 'package:schedderum/providers/week_context_provider.dart';
import 'package:schedderum/util/snackbar_service.dart';

class AddRecordModal extends ConsumerStatefulWidget {
  final DateTime date;
  final String day;
  final String weekday;
  final String departmentId;

  const AddRecordModal({
    super.key,
    required this.date,
    required this.day,
    required this.weekday,
    required this.departmentId,
  });

  @override
  ConsumerState<AddRecordModal> createState() => _AddRecordModalState();
}

class _AddRecordModalState extends ConsumerState<AddRecordModal> {
  Employee? selectedEmployee;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  RecordType selectedType = RecordType.SHIFT;
  bool isAllDay = false;

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
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

    final startDateTime = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      isTimed ? startTime!.hour : 0,
      isTimed ? startTime!.minute : 0,
    );

    final endDateTime = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      isTimed ? endTime!.hour : 23,
      isTimed ? endTime!.minute : 59,
    );

    if (startDateTime.isAfter(endDateTime)) {
      SnackBarService.showNegativeSnackBar(
        context: context,
        message: "Start time must be before end time",
      );
      return;
    }

    final newRecord = db.Record(
      id: uuid(),
      start: startDateTime,
      end: endDateTime,
      type: selectedType.name,
      employeeId: selectedEmployee!.id,
    );

    final weekStart = startOfWeek(widget.date);
    final weekEnd = endOfWeek(weekStart);

    final result = await ref
        .read(recordsProvider(widget.departmentId, weekStart, weekEnd).notifier)
        .addRecord(newRecord, widget.departmentId, weekStart, weekEnd);

    result.match(
      (l) => SnackBarService.showNegativeSnackBar(
        context: context,
        message: "Failed to add record: ${l.message}",
      ),
      (r) => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(
      employeesByDepartmentProvider(widget.departmentId),
    );

    return AlertDialog(
      title: Text("Add new record — ${widget.weekday} ${widget.day}"),
      content: employeesAsync.when(
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
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<Employee>(
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
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          spacing: 8,
                          children:
                              RecordType.values
                                  .where(
                                    (t) =>
                                        t == RecordType.SHIFT ||
                                        t == RecordType.UNAVAILABLE ||
                                        t == RecordType.SICK,
                                  )
                                  .map(
                                    (type) => ChoiceChip(
                                      label: Text(type.name),
                                      selected: selectedType == type,
                                      onSelected: (_) {
                                        setState(() {
                                          selectedType = type;
                                          isAllDay = type == RecordType.SICK;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (selectedType == RecordType.UNAVAILABLE)
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text("All Day"),
                          value: isAllDay,
                          onChanged: (v) => setState(() => isAllDay = v),
                        ),
                      if (selectedType == RecordType.SHIFT || !isAllDay)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: FilledButton.tonalIcon(
                                  icon: const Icon(Icons.schedule),
                                  label: Text(
                                    startTime == null
                                        ? "Start"
                                        : startTime!.format(context),
                                  ),
                                  onPressed: () => _pickTime(context, true),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FilledButton.tonalIcon(
                                  icon: const Icon(Icons.schedule),
                                  label: Text(
                                    endTime == null
                                        ? "End"
                                        : endTime!.format(context),
                                  ),
                                  onPressed: () => _pickTime(context, false),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.check),
          label: const Text("Add"),
        ),
      ],
    );
  }
}
