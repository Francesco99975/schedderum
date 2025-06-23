import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:schedderum/models/display_record.dart';
import 'package:schedderum/models/record.dart';
import 'package:schedderum/providers/settings_provider.dart';
import 'package:schedderum/util/responsive.dart';

class EmployeeRecordItem extends ConsumerWidget {
  final DisplayRecord displayRecord;
  final Function onDismissed;

  const EmployeeRecordItem({
    super.key,
    required this.displayRecord,
    required this.onDismissed,
  });

  String _formatDuration(Duration duration) {
    double hours = duration.inMinutes / 60.0;
    if (hours == hours.roundToDouble()) {
      return "${hours.toInt()}H";
    }
    return "${hours.toStringAsFixed(1)}H";
  }

  // Future<void> _openForm(BuildContext context, [Record? existing]) async {
  //   await showDialog<Record>(
  //     context: context,
  //     builder: (BuildContext context) {},
  //   );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTimeFormatter = ref.watch(activeDateFormatterProvider);
    final duration = displayRecord.record.duration;
    final borderColor =
        displayRecord.record.type == RecordType.SHIFT
            ? Colors.lightBlueAccent
            : displayRecord.record.type == RecordType.SICK
            ? Colors.red
            : displayRecord.record.type == RecordType.VACATION
            ? Colors.amber
            : Colors.grey.shade300;

    return Dismissible(
      key: ValueKey(displayRecord.record.id),
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
                    "Do you want to remove this record?",
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
          side: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: ListTile(
          onTap: () {}, //_openForm(context, displayRecord.record),
          leading: CircleAvatar(
            backgroundColor: Color(displayRecord.employeeColor),
            child: Text(
              _formatDuration(duration),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: getContrastingTextColor(
                  Color(displayRecord.employeeColor),
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            displayRecord.employeeFullName,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            _determineRecordType(
              displayRecord.record.type,
              activeTimeFormatter,
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }

  String _determineRecordType(RecordType type, DateFormat activeTimeFormatter) {
    switch (type) {
      case RecordType.SHIFT:
        return "${activeTimeFormatter.format(displayRecord.record.start)} - ${activeTimeFormatter.format(displayRecord.record.end)}";
      case RecordType.SICK:
        return "Sick";
      case RecordType.UNAVAILABLE:
        return "Unavailable";
      case RecordType.VACATION:
        return "Vacation";
    }
  }
}
