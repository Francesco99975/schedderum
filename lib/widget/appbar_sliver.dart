import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/providers/departments.dart';
import 'package:schedderum/util/formatters.dart';
import 'package:schedderum/widget/department_selector.dart';
import 'package:schedderum/widget/settings_dropdown.dart';

class AppHeaderBarSliver extends ConsumerWidget {
  final DateTime weekStart;
  final DateTime weekEnd;

  const AppHeaderBarSliver({
    super.key,
    required this.weekStart,
    required this.weekEnd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDepartment = ref.watch(departmentsProvider.notifier).current;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 500;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LEFT: Department Selector (with overflow protection)
                    selectedDepartment.match(
                      () => const SizedBox.shrink(),
                      (currentDept) => Flexible(
                        flex: 0,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: DepartmentPopupMenu(),
                        ),
                      ),
                    ),

                    // CENTER: Chip (only shown on wider screens)
                    if (!isMobile)
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: selectedDepartment.match(
                            () => const SizedBox.shrink(),
                            (currentDept) {
                              final duration = currentDept.getRangedDuration(
                                weekStart,
                                weekEnd,
                              );
                              return Chip(
                                label: Text(
                                  formatDuration(duration),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                avatar: const Icon(Icons.access_time, size: 18),
                                backgroundColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    // RIGHT: Settings Dropdown (always fixed)
                    const SizedBox(width: 12),
                    const SettingsDropdown(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
