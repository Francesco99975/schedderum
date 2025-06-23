import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:schedderum/helpers/uuid.dart';
import 'package:schedderum/models/employee.dart';
import 'package:schedderum/providers/employees.dart';

class EmployeeFormDialog extends ConsumerStatefulWidget {
  final Employee? initial;
  final String currentDepartmentId;

  const EmployeeFormDialog({
    super.key,
    this.initial,
    required this.currentDepartmentId,
  });

  @override
  ConsumerState<EmployeeFormDialog> createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends ConsumerState<EmployeeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String firstname, middlename, lastname, email, phone;
  late int priority;
  late bool isManager;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    final e = widget.initial;
    firstname = e?.firstname ?? '';
    middlename = e?.middlename ?? '';
    lastname = e?.lastname ?? '';
    email = e?.email ?? '';
    phone = e?.phone ?? '';
    priority = e?.priority ?? 0;
    isManager = e?.isManager ?? false;
    selectedColor = Color(e?.color ?? Colors.blue.toARGB32());
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final emp = Employee(
      id: widget.initial?.id ?? uuid(),
      firstname: firstname,
      middlename: middlename,
      lastname: lastname,
      email: email,
      phone: phone,
      priority: priority,
      isManager: isManager,
      color: selectedColor.toARGB32(),
      records: widget.initial?.records ?? [],
    );

    final prov = ref.read(employeesProvider.notifier);
    final result =
        widget.initial == null
            ? await prov.addEmployee(emp.toDbModel(widget.currentDepartmentId))
            : await prov.updateEmployee(
              emp.toDbModel(widget.currentDepartmentId),
            );

    result.match(
      (l) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${l.message}'))),
      (_) => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return AlertDialog(
          title: Text(
            widget.initial == null ? 'Add Employee' : 'Edit Employee',
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Wrap(
                  runSpacing: 12,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: firstname,
                            decoration: const InputDecoration(
                              labelText: 'First name',
                              border: OutlineInputBorder(),
                            ),
                            validator:
                                (v) =>
                                    v == null || v.isEmpty ? 'Required' : null,
                            onSaved: (v) => firstname = v!,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: middlename,
                            decoration: const InputDecoration(
                              labelText: 'Middle name',
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (v) => middlename = v ?? '',
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      initialValue: lastname,
                      decoration: const InputDecoration(
                        labelText: 'Last name',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (v) => v == null || v.isEmpty ? 'Required' : null,
                      onSaved: (v) => lastname = v!,
                    ),
                    TextFormField(
                      initialValue: email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (v) => email = v ?? '',
                    ),
                    TextFormField(
                      initialValue: phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (v) => phone = v ?? '',
                    ),
                    TextFormField(
                      initialValue: priority.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator:
                          (v) =>
                              int.tryParse(v ?? '') == null
                                  ? 'Invalid number'
                                  : null,
                      onSaved: (v) => priority = int.parse(v!),
                    ),
                    SwitchListTile(
                      title: const Text('Manager'),
                      value: isManager,
                      onChanged: (v) => setState(() => isManager = v),
                    ),
                    Row(
                      children: [
                        Text(
                          'Color:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => _openColorPicker(context),
                          child: CircleAvatar(
                            backgroundColor: selectedColor,
                            radius: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(onPressed: _onSubmit, child: const Text('Save')),
          ],
        );
      },
    );
  }

  void _openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Pick Color'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (c) => setState(() => selectedColor = c),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
