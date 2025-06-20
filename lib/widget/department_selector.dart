import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/helpers/uuid.dart';
import 'package:schedderum/models/department.dart';
import 'package:schedderum/providers/departments.dart';
import 'package:schedderum/util/formatters.dart';

class DepartmentPopupMenu extends ConsumerStatefulWidget {
  const DepartmentPopupMenu({super.key});

  @override
  ConsumerState<DepartmentPopupMenu> createState() =>
      _DepartmentPopupMenuState();
}

class _DepartmentPopupMenuState extends ConsumerState<DepartmentPopupMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentDepartmentAsync = ref.watch(currentDepartmentProvider);

    return GestureDetector(
      onTap: () async {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset.zero, ancestor: overlay),
            button.localToGlobal(
              button.size.bottomRight(Offset.zero),
              ancestor: overlay,
            ),
          ),
          Offset.zero & overlay.size,
        );

        await showMenu(
          context: context,
          position: position,
          items: [
            PopupMenuItem(
              enabled: false,
              child: StatefulBuilder(
                builder: (context, setMenuState) {
                  return Consumer(
                    builder: (context, ref, _) {
                      final departmentsAsync = ref.watch(departmentsProvider);
                      final selectedAsync = ref.watch(
                        currentDepartmentProvider,
                      );

                      return departmentsAsync.when(
                        loading:
                            () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        error:
                            (_, __) => const Text('Failed to load departments'),
                        data:
                            (either) => either.fold(
                              (failure) => Text('Error: ${failure.message}'),
                              (departments) {
                                String? selectedId;
                                selectedAsync.whenData((opt) {
                                  opt.fold(
                                    () {},
                                    (dept) => selectedId = dept.id,
                                  );
                                });

                                return ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 240,
                                    maxWidth: 300,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (final dept in departments)
                                        DepartmentRow(
                                          dept: dept,
                                          isSelected: selectedId == dept.id,
                                          onSelect: () {
                                            ref
                                                .read(
                                                  currentDepartmentProvider
                                                      .notifier,
                                                )
                                                .setCurrent(dept.id);
                                            Navigator.pop(context);
                                          },
                                          onRename: (newName) async {
                                            await ref
                                                .read(
                                                  departmentsProvider.notifier,
                                                )
                                                .updateDepartment(
                                                  dept
                                                      .copyWith(name: newName)
                                                      .toDbModel(),
                                                );
                                          },
                                          onDelete: () async {
                                            await ref
                                                .read(
                                                  departmentsProvider.notifier,
                                                )
                                                .removeDepartment(
                                                  dept.toDbModel(),
                                                );
                                          },
                                        ),
                                      const Divider(),
                                      NewDepartmentRow(
                                        onCreate: (name) async {
                                          await ref
                                              .read(
                                                departmentsProvider.notifier,
                                              )
                                              .addDepartment(
                                                Department(
                                                  id: uuid(),
                                                  name: name,
                                                  employees: [],
                                                ).toDbModel(),
                                              );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.primary.withAlpha(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: currentDepartmentAsync.when(
                loading: () => const Text('Loading...'),
                error: (_, __) => const Text('Error'),
                data:
                    (opt) => opt.fold(
                      () => const Text('No department selected'),
                      (selected) => Text(
                        '${selected.name} (${formatDuration(selected.getRangedDuration(DateTime.now(), DateTime.now().add(Duration(days: 7))))})',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class DepartmentRow extends StatefulWidget {
  final Department dept;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onDelete;
  final ValueChanged<String> onRename;

  const DepartmentRow({
    super.key,
    required this.dept,
    required this.isSelected,
    required this.onSelect,
    required this.onDelete,
    required this.onRename,
  });

  @override
  State<DepartmentRow> createState() => _DepartmentRowState();
}

class _DepartmentRowState extends State<DepartmentRow> {
  bool editing = false;
  bool confirming = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.dept.name);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _save() {
    final name = controller.text.trim();
    if (name.isNotEmpty && name != widget.dept.name) {
      widget.onRename(name);
    }
    setState(() => editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration:
          widget.isSelected
              ? BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
              )
              : null,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child:
                editing
                    ? TextField(
                      controller: controller,
                      autofocus: true,
                      onSubmitted: (_) => _save(),
                    )
                    : GestureDetector(
                      onTap: widget.onSelect,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          '${widget.dept.name} (${formatDuration(widget.dept.getRangedDuration(DateTime.now(), DateTime.now().add(Duration(days: 7))))})',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight:
                                widget.isSelected ? FontWeight.bold : null,
                            color:
                                widget.isSelected
                                    ? theme.colorScheme.primary
                                    : null,
                          ),
                        ),
                      ),
                    ),
          ),
          if (confirming)
            Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: theme.colorScheme.error.withAlpha(30),
                  ),
                  onPressed: widget.onDelete,
                  child: Text(
                    'Delete',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
                const SizedBox(width: 4),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary.withAlpha(30),
                  ),
                  onPressed: () => setState(() => confirming = false),
                  child: const Text('Cancel'),
                ),
              ],
            )
          else ...[
            IconButton(
              icon: Icon(editing ? Icons.check : Icons.edit, size: 18),
              onPressed: () {
                if (editing) {
                  _save();
                } else {
                  setState(() => editing = true);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => setState(() => confirming = true),
            ),
          ],
        ],
      ),
    );
  }
}

class NewDepartmentRow extends StatefulWidget {
  final ValueChanged<String> onCreate;

  const NewDepartmentRow({super.key, required this.onCreate});

  @override
  State<NewDepartmentRow> createState() => _NewDepartmentRowState();
}

class _NewDepartmentRowState extends State<NewDepartmentRow> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _create() {
    final name = controller.text.trim();
    if (name.isNotEmpty) {
      widget.onCreate(name);
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'New department',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onSubmitted: (_) => _create(),
          ),
        ),
        IconButton(icon: const Icon(Icons.add), onPressed: _create),
      ],
    );
  }
}
