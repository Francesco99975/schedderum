import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/providers/departments.dart';
import 'package:schedderum/database/database.dart';

class DepartmentPopupMenu extends ConsumerStatefulWidget {
  const DepartmentPopupMenu({super.key});

  @override
  ConsumerState<DepartmentPopupMenu> createState() =>
      _DepartmentPopupMenuState();
}

class _DepartmentPopupMenuState extends ConsumerState<DepartmentPopupMenu> {
  String? editingId;
  final Map<String, TextEditingController> _controllers = {};
  final TextEditingController _newController = TextEditingController();

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _newController.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final departmentsAsync = ref.watch(departmentsProvider);

    return departmentsAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
      data:
          (either) => either.match((f) => Text('Error: ${f.message}'), (
            departments,
          ) {
            return GestureDetector(
              onTap: () async {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
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
                      child: Consumer(
                        builder: (context, ref, _) {
                          final current =
                              ref.watch(departmentsProvider.notifier).current;
                          final departmentsAsync = ref.watch(
                            departmentsProvider,
                          );

                          return departmentsAsync.when(
                            loading: () => const CircularProgressIndicator(),
                            error: (e, _) => Text('Error: $e'),
                            data:
                                (
                                  either,
                                ) => either.match((f) => Text('Error: ${f.message}'), (
                                  departments,
                                ) {
                                  return StatefulBuilder(
                                    builder: (context, setMenuState) {
                                      void updateMenu() {
                                        setMenuState(() {});
                                        _rebuild();
                                      }

                                      return ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          minWidth: 240,
                                          maxWidth: 300,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ...departments.map((dept) {
                                              final isEditing =
                                                  editingId == dept.id;
                                              final controller = _controllers
                                                  .putIfAbsent(
                                                    dept.id,
                                                    () => TextEditingController(
                                                      text: dept.name,
                                                    ),
                                                  );
                                              final isSelected = current.fold(
                                                () => false,
                                                (d) => d.id == dept.id,
                                              );
                                              final isLast =
                                                  departments.length == 1;

                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        isEditing
                                                            ? TextField(
                                                              controller:
                                                                  controller,
                                                              autofocus: true,
                                                              onSubmitted: (_) {
                                                                _saveEdit(
                                                                  dept.toDbModel(),
                                                                );
                                                                updateMenu();
                                                              },
                                                            )
                                                            : GestureDetector(
                                                              onTap: () {
                                                                ref
                                                                    .read(
                                                                      departmentsProvider
                                                                          .notifier,
                                                                    )
                                                                    .setCurrent(
                                                                      dept.id,
                                                                    );
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8,
                                                                    ),
                                                                child: Text(
                                                                  dept.name,
                                                                  style:
                                                                      theme
                                                                          .textTheme
                                                                          .bodyMedium,
                                                                ),
                                                              ),
                                                            ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      isEditing
                                                          ? Icons.check
                                                          : Icons.edit,
                                                      size: 18,
                                                    ),
                                                    onPressed: () {
                                                      if (isEditing) {
                                                        _saveEdit(
                                                          dept.toDbModel(),
                                                        );
                                                      } else {
                                                        editingId = dept.id;
                                                      }
                                                      updateMenu();
                                                    },
                                                  ),
                                                  if (!isLast && !isSelected)
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.close,
                                                        size: 18,
                                                      ),
                                                      onPressed: () async {
                                                        await ref
                                                            .read(
                                                              departmentsProvider
                                                                  .notifier,
                                                            )
                                                            .removeDepartment(
                                                              dept.toDbModel(),
                                                            );
                                                        updateMenu();
                                                      },
                                                    )
                                                  else
                                                    const SizedBox(width: 40),
                                                ],
                                              );
                                            }),
                                            const Divider(),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: _newController,
                                                    decoration:
                                                        const InputDecoration(
                                                          hintText: 'new dept',
                                                          isDense: true,
                                                        ),
                                                    onSubmitted: (_) {
                                                      _createNew();
                                                      updateMenu();
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.add),
                                                  onPressed: () {
                                                    _createNew();
                                                    updateMenu();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }),
                          );
                        },
                      ),
                    ),
                  ],
                );
                editingId = null;
                _rebuild();
              },
              child: Consumer(
                builder: (context, ref, _) {
                  final selected = ref
                      .watch(departmentsProvider.notifier)
                      .current
                      .map((d) => d.name)
                      .getOrElse(() => 'Select Dept');
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            selected,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
    );
  }

  void _saveEdit(Department dept) {
    final name = _controllers[dept.id]?.text.trim();
    if (name != null && name.isNotEmpty && name != dept.name) {
      final updated = dept.copyWith(name: name);
      ref.read(departmentsProvider.notifier).updateDepartment(updated);
    }
    editingId = null;
  }

  void _createNew() {
    final name = _newController.text.trim();
    if (name.isNotEmpty) {
      final newDept = Department(id: UniqueKey().toString(), name: name);
      ref.read(departmentsProvider.notifier).addDepartment(newDept);
      _newController.clear();
    }
  }
}
