import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/helpers/uuid.dart';
import 'package:schedderum/models/department.dart';
import 'package:schedderum/providers/departments.dart';
import 'package:schedderum/database/database.dart' as db;
import 'package:schedderum/widget/async_provider_comparer.dart';

class DepartmentSelector extends ConsumerStatefulWidget {
  final Department selected;
  final ValueChanged<Department> onDepartmentChanged;

  const DepartmentSelector({
    super.key,
    required this.selected,
    required this.onDepartmentChanged,
  });

  @override
  ConsumerState<DepartmentSelector> createState() => _DepartmentSelectorState();
}

class _DepartmentSelectorState extends ConsumerState<DepartmentSelector> {
  bool _expanded = false;

  Future<void> _showDepartmentDialog({Department? editing}) async {
    final controller = TextEditingController(text: editing?.name ?? '');

    final result = await showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(editing == null ? "New Department" : "Edit Department"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Department Name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) Navigator.pop(context, name);
                },
                child: Text(editing == null ? "Add" : "Update"),
              ),
            ],
          ),
    );

    if (result != null) {
      if (editing != null) {
        final updated = editing.copyWith(name: result).toDbModel();
        await ref.read(departmentsProvider.notifier).updateDepartment(updated);
      } else {
        await ref
            .read(departmentsProvider.notifier)
            .addDepartment(db.Department(id: uuid(), name: result));
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, Department dept) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Delete Department"),
            content: Text("Are you sure you want to delete '${dept.name}'?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Delete"),
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      await ref
          .read(departmentsProvider.notifier)
          .removeDepartment(dept.toDbModel());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AsyncProviderComparer(
      provider: departmentsProvider,
      future: departmentsProvider.future,
      render:
          (departments) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child:
                _expanded
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...departments.map((dept) {
                          return ListTile(
                            title: Text(dept.name),
                            onTap: () {
                              widget.onDepartmentChanged(dept);
                              setState(() => _expanded = false);
                            },
                            onLongPress:
                                () => _showDepartmentDialog(editing: dept),
                            trailing:
                                dept.id != widget.selected.id
                                    ? IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed:
                                          () => _confirmDelete(context, dept),
                                    )
                                    : null,
                          );
                        }),
                        TextButton.icon(
                          onPressed: () => _showDepartmentDialog(),
                          icon: const Icon(Icons.add),
                          label: const Text("Add New Dept"),
                        ),
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_up),
                          onPressed: () => setState(() => _expanded = false),
                        ),
                      ],
                    )
                    : GestureDetector(
                      onTap: () => setState(() => _expanded = true),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.selected.name),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
          ),
    );
  }
}
