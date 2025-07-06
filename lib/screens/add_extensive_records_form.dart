import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:schedderum/database/database.dart' as db;
import 'package:schedderum/helpers/uuid.dart';
import 'package:schedderum/models/employee.dart';
import 'package:schedderum/models/record.dart';
import 'package:schedderum/providers/employees.dart';
import 'package:schedderum/providers/records.dart';
import 'package:schedderum/providers/week_context_provider.dart';
import 'package:schedderum/util/snackbar_service.dart';

class AddExtensiveRecordFormScreen extends ConsumerStatefulWidget {
  static const routePath = "/extensive";
  final String departmentId;

  const AddExtensiveRecordFormScreen({super.key, required this.departmentId});

  @override
  ConsumerState<AddExtensiveRecordFormScreen> createState() =>
      _AddExtensiveRecordFormScreenState();
}

class _AddExtensiveRecordFormScreenState
    extends ConsumerState<AddExtensiveRecordFormScreen> {
  Employee? selectedEmployee;
  RecordType? selectedType;
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (startDate ?? now) : (endDate ?? now),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (endDate != null && picked.isAfter(endDate!)) {
            endDate = picked;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (selectedEmployee == null ||
        selectedType == null ||
        startDate == null ||
        endDate == null) {
      SnackBarService.showNegativeSnackBar(
        context: context,
        message: "All fields are required",
      );
      return;
    }

    if (startDate!.isAfter(endDate!)) {
      SnackBarService.showNegativeSnackBar(
        context: context,
        message: "Start date must be before end date",
      );
      return;
    }

    final weekStart = startOfWeek(startDate!);
    final weekEnd = endOfWeek(endDate!);

    List<db.Record> records = [];
    for (
      DateTime d = startDate!;
      !d.isAfter(endDate!);
      d = d.add(const Duration(days: 1))
    ) {
      records.add(
        db.Record(
          id: uuid(),
          start: DateTime(d.year, d.month, d.day, 0, 0),
          end: DateTime(d.year, d.month, d.day, 23, 59),
          type: selectedType!.name,
          employeeId: selectedEmployee!.id,
        ),
      );
    }

    for (final record in records) {
      await ref
          .read(
            recordsProvider(widget.departmentId, weekStart, weekEnd).notifier,
          )
          .addRecord(record, widget.departmentId, weekStart, weekEnd);
    }

    if (!mounted) return;

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(
      employeesByDepartmentProvider(widget.departmentId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Extended Record")),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: employeesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data:
              (either) => either.match(
                (failure) => Center(child: Text("Error: ${failure.message}")),
                (employees) => SingleChildScrollView(
                  child: Column(
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
                            (e) => setState(() {
                              selectedEmployee = e;
                            }),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<RecordType>(
                        value: selectedType,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "Record Type",
                          border: OutlineInputBorder(),
                        ),
                        items:
                            [
                              RecordType.UNAVAILABLE,
                              RecordType.VACATION,
                              RecordType.TIME_OFF,
                            ].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type.name),
                              );
                            }).toList(),
                        onChanged:
                            (type) => setState(() {
                              selectedType = type;
                            }),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonalIcon(
                              icon: const Icon(Icons.date_range),
                              label: Text(
                                startDate == null
                                    ? "Start Date"
                                    : "${startDate!.year}/${startDate!.month}/${startDate!.day}",
                              ),
                              onPressed: () => _pickDate(context, true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.tonalIcon(
                              icon: const Icon(Icons.date_range),
                              label: Text(
                                endDate == null
                                    ? "End Date"
                                    : "${endDate!.year}/${endDate!.month}/${endDate!.day}",
                              ),
                              onPressed: () => _pickDate(context, false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text("Create Records"),
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
