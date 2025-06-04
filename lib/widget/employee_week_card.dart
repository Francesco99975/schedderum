import 'package:flutter/material.dart';
import 'package:schedderum/models/employee.dart';
import 'package:schedderum/util/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeWeekCard extends StatelessWidget {
  final Employee employee;
  final DateTime from;
  final DateTime to;

  const EmployeeWeekCard({
    super.key,
    required this.employee,
    required this.from,
    required this.to,
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

  @override
  Widget build(BuildContext context) {
    final borderColor =
        employee.isManager ? Colors.amber : Colors.grey.shade300;
    final borderWidth = employee.isManager ? 2.5 : 1.0;

    final duration = employee.getRangedDuration(from, to);
    final shiftCount = employee.weekStatus(from, to);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(employee.color),
            radius: 24,
            child: Text(
              _formatDuration(duration),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: getContrastingTextColor(Color(employee.color)),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.getFullName(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  shiftCount,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
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
    );
  }
}
