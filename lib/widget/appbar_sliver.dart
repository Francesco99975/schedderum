import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/models/department.dart';
import 'package:schedderum/providers/departments.dart';
import 'package:schedderum/providers/week_context_provider.dart';
import 'package:schedderum/util/formatters.dart';
import 'package:schedderum/widget/async_provider_replacer.dart';
import 'package:schedderum/widget/department_selector.dart';
import 'package:schedderum/widget/settings_dropdown.dart';

class AppHeaderBarSliver extends ConsumerWidget {
  final Department selectedDepartment;
  final DateTime weekStart;

  const AppHeaderBarSliver({
    super.key,
    required this.selectedDepartment,
    required this.weekStart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekController = ref.read(weekContextProvider.notifier);
    final weekEnd = endOfWeek(weekStart);
    final duration = selectedDepartment.getRangedDuration(weekStart, weekEnd);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
          shadowColor: Theme.of(context).shadowColor.withAlpha(40),
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AsyncProviderReplacer(
                          provider: departmentsProvider,
                          fallback: (l) => Text("Error: ${l.message}"),
                          render: (_) => DepartmentPopupMenu(),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Center(
                            child: Chip(
                              label: Text(
                                formatDuration(duration),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              avatar: const Icon(
                                Icons.access_time,
                                size: 18,
                                semanticLabel: 'Worked hours',
                              ),
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
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // RIGHT: Settings Dropdown
                        const SettingsDropdown(),
                      ],
                    );
                  },
                ),
              ),

              const Divider(height: 1),

              // WEEK NAVIGATION FOOTER
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      tooltip: 'Previous week',
                      onPressed: () => weekController.previousWeek(),
                    ),
                    Column(
                      children: [
                        Text(
                          '${formatShortDate(weekStart)} → ${formatShortDate(weekEnd)}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.today, size: 18),
                          label: const Text("Today"),
                          onPressed: () => weekController.resetToCurrentWeek(),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      tooltip: 'Next week',
                      onPressed: () => weekController.nextWeek(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
