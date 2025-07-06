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

  bool get _canSubmit =>
      selectedEmployee != null &&
      selectedType != null &&
      startDate != null &&
      endDate != null &&
      !startDate!.isAfter(endDate!);

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

    if (mounted) {
      context.pop();
    }
  }

  Future<void> _handleDelete() async {
    final weekStart = startOfWeek(startDate!);
    final weekEnd = endOfWeek(endDate!);

    final result = await ref.read(
      recordsProvider(widget.departmentId, weekStart, weekEnd).future,
    );

    result.match(
      (failure) => SnackBarService.showNegativeSnackBar(
        context: context,
        message: "Failed to load records",
      ),
      (records) async {
        final toDelete =
            records.where((r) {
              final matchEmployee = r.employeeId == selectedEmployee!.id;
              final matchType = r.record.type == selectedType;
              final matchDate =
                  !r.record.start.isBefore(startDate!) &&
                  !r.record.end.isAfter(endDate!.add(const Duration(days: 1)));
              return matchEmployee && matchType && matchDate;
            }).toList();

        if (toDelete.isEmpty) {
          SnackBarService.showPositiveSnackBar(
            context: context,
            message: "No matching records to delete",
          );
          return;
        }

        for (final r in toDelete) {
          await ref
              .read(
                recordsProvider(
                  widget.departmentId,
                  weekStart,
                  weekEnd,
                ).notifier,
              )
              .removeRecord(
                r.record.toDbModel(r.employeeId),
                widget.departmentId,
                weekStart,
                weekEnd,
              );
        }

        if (mounted) {
          SnackBarService.showPositiveSnackBar(
            context: context,
            message: "${toDelete.length} record(s) deleted",
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final employeesAsync = ref.watch(
      employeesByDepartmentProvider(widget.departmentId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Extended Record")),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: employeesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data:
              (either) => either.match(
                (failure) => Center(child: Text("Error: ${failure.message}")),
                (employees) => Column(
                  children: [
                    DropdownButtonFormField<Employee>(
                      value: selectedEmployee,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "Employee",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
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
                      onChanged: (e) => setState(() => selectedEmployee = e),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<RecordType>(
                      value: selectedType,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "Record Type",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.event_note),
                      ),
                      items:
                          [
                                RecordType.UNAVAILABLE,
                                RecordType.VACATION,
                                RecordType.TIME_OFF,
                              ]
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.name),
                                ),
                              )
                              .toList(),
                      onChanged: (t) => setState(() => selectedType = t),
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
                    const Spacer(),
                    FilledButton.icon(
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Create Records"),
                      onPressed: _canSubmit ? _submit : null,
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      icon: const Icon(Icons.delete_forever),
                      label: const Text("Delete Records"),
                      style: FilledButton.styleFrom(
                        backgroundColor: palette.error,
                        foregroundColor: palette.onError,
                      ),
                      onPressed: _canSubmit ? _handleDelete : null,
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
