import 'package:schedderum/models/record.dart';

class DisplayRecord {
  final Record record;
  final String employeeFullName;
  final int employeeColor;
  final String employeeId;

  DisplayRecord({
    required this.record,
    required this.employeeFullName,
    required this.employeeColor,
    required this.employeeId,
  });
}
