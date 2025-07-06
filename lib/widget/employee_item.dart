import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/models/employee.dart';
import 'package:schedderum/providers/settings_provider.dart';
import 'package:schedderum/util/formatters.dart';
import 'package:schedderum/util/responsive.dart';
import 'package:schedderum/widget/employee_form_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeItem extends ConsumerWidget {
  final Employee employee;
  final DateTime from;
  final DateTime to;
  final Function onDismissed;
  final String currentDepartmentId;

  const EmployeeItem({
    super.key,
    required this.employee,
    required this.from,
    required this.to,
    required this.onDismissed,
    required this.currentDepartmentId,
  });

  void _launchPhone(String phone) async {
    final uri = Uri.parse("tel:$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _formatDuration(Duration duration) {
    double hours = duration.inMinutes / 60.0;
    if (hours == hours.roundToDouble()) {
      return "${hours.toInt()}H";
    }
    return "${hours.toStringAsFixed(1)}H";
  }

  Future<void> _openForm(
    String currentDepartmentId,
    BuildContext context, [
    Employee? existing,
  ]) async {
    await showDialog<Employee>(
      context: context,
      builder:
          (BuildContext context) => EmployeeFormDialog(
            initial: existing,
            currentDepartmentId: currentDepartmentId,
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final duration = employee.getRangedDuration(from, to);
    final shiftCount = employee.weekStatus(from, to);
    final color = Color(employee.color);
    final borderColor =
        employee.isManager ? Colors.amber : Colors.grey.shade300;

    return Dismissible(
      key: ValueKey(employee.id),
      direction: DismissDirection.startToEnd, // left to right
      onDismissed: (direction) => onDismissed(direction),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          return await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: Text(
                    "Are you sure ?",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  content: Text(
                    "Do you want to remove this employee?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "No",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.red),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text(
                        "Yes",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.green),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
          );
        }
        return false;
      },
      background: Container(
        color: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor,
            width: employee.isManager ? 2.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: ListTile(
          onTap: () => _openForm(currentDepartmentId, context, employee),
          leading: settingsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => const Icon(Icons.error),
            data:
                (settings) => CircleAvatar(
                  backgroundColor: color,
                  child:
                      shiftCount.contains("shift")
                          ? Text(
                            _formatDuration(
                              regulatedDuration(
                                duration,
                                settings.breakFrequencyHours,
                                settings.breakDurationHours,
                              ),
                            ),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: getContrastingTextColor(color),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : Icon(
                            Icons.person,
                            color: getContrastingTextColor(color),
                          ),
                ),
          ),
          title: Text(
            employee.getFullName(),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            shiftCount,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
          ),
          trailing: Wrap(
            spacing: 6,
            children: [
              IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () => _launchPhone(employee.phone),
              ),
              IconButton(
                icon: const Icon(Icons.mail),
                onPressed: () => _launchEmail(employee.email),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
