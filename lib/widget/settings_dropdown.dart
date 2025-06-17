import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/providers/settings_provider.dart';

class SettingsDropdown extends ConsumerWidget {
  const SettingsDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return PopupMenuButton<int>(
      icon: const Icon(Icons.settings),
      itemBuilder: (context) {
        return settingsAsync.when(
          data:
              (settings) => [
                PopupMenuItem(
                  enabled: false,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final currentSettings =
                          ref.watch(settingsProvider).value!;
                      return SwitchListTile(
                        title: Text(
                          'Dark Mode',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: currentSettings.darkMode,
                        onChanged:
                            (val) => ref
                                .read(settingsProvider.notifier)
                                .toggleDarkMode(val),
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),
                PopupMenuItem(
                  enabled: false,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final currentSettings =
                          ref.watch(settingsProvider).value!;
                      return SwitchListTile(
                        title: Text(
                          '24H Format',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: currentSettings.useMilitaryTime,
                        onChanged:
                            (val) => ref
                                .read(settingsProvider.notifier)
                                .setMilitaryTime(val),
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  enabled: false,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final currentSettings =
                          ref.watch(settingsProvider).value!;
                      return ListTile(
                        title: Text(
                          'Break Frequency',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              splashRadius: 16,
                              padding: EdgeInsets.zero,
                              onPressed:
                                  () => ref
                                      .read(settingsProvider.notifier)
                                      .setBreakFrequency(
                                        (currentSettings.breakFrequencyHours -
                                                0.5)
                                            .clamp(0.0, 24.0),
                                      ),
                            ),
                            Text('${currentSettings.breakFrequencyHours}h'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              splashRadius: 16,
                              padding: EdgeInsets.zero,
                              onPressed:
                                  () => ref
                                      .read(settingsProvider.notifier)
                                      .setBreakFrequency(
                                        (currentSettings.breakFrequencyHours +
                                                0.5)
                                            .clamp(0.0, 24.0),
                                      ),
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),
                PopupMenuItem(
                  enabled: false,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final currentSettings =
                          ref.watch(settingsProvider).value!;
                      return ListTile(
                        title: Text(
                          'Break Duration',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              splashRadius: 16,
                              padding: EdgeInsets.zero,
                              onPressed:
                                  () => ref
                                      .read(settingsProvider.notifier)
                                      .setBreakDuration(
                                        (currentSettings.breakDurationHours -
                                                0.5)
                                            .clamp(0.0, 8.0),
                                      ),
                            ),
                            Text('${currentSettings.breakDurationHours}h'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              splashRadius: 16,
                              padding: EdgeInsets.zero,
                              onPressed:
                                  () => ref
                                      .read(settingsProvider.notifier)
                                      .setBreakDuration(
                                        (currentSettings.breakDurationHours +
                                                0.5)
                                            .clamp(0.0, 8.0),
                                      ),
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),
              ],
          loading:
              () => [
                PopupMenuItem(
                  enabled: false,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ],
          error:
              (err, _) => [
                PopupMenuItem(
                  enabled: false,
                  child: const Text('Error loading settings'),
                ),
              ],
        );
      },
    );
  }
}
