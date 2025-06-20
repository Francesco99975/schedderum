import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/models/department.dart';
import 'package:schedderum/models/employee.dart';
import 'package:schedderum/providers/departments.dart';
import 'package:schedderum/providers/week_context_provider.dart';
import 'package:schedderum/widget/employee_item.dart';

class EmployeesScreen extends ConsumerStatefulWidget {
  final Department currentDepartment;
  final DateTime weekStart;
  const EmployeesScreen({
    super.key,
    required this.currentDepartment,
    required this.weekStart,
  });

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

enum EmployeeSortOption { defaultOrder, hours, firstName, lastName, shiftCount }

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  EmployeeSortOption _sortOption = EmployeeSortOption.defaultOrder;
  bool _isDescending = true;

  @override
  Widget build(BuildContext context) {
    final weekStart = widget.weekStart;
    final weekEnd = endOfWeek(weekStart);
    final employees = widget.currentDepartment.employees;
    employees.sort((a, b) {
      int result;
      switch (_sortOption) {
        case EmployeeSortOption.hours:
          result = b
              .getRangedDuration(weekStart, weekEnd)
              .compareTo(a.getRangedDuration(weekStart, weekEnd));
          break;
        case EmployeeSortOption.firstName:
          result = a.firstname.compareTo(b.firstname);
          break;
        case EmployeeSortOption.lastName:
          result = a.lastname.compareTo(b.lastname);
          break;
        case EmployeeSortOption.shiftCount:
          result = b
              .getWeeklyShiftCount(weekStart, weekEnd)
              .compareTo(a.getWeeklyShiftCount(weekStart, weekEnd));
          break;
        case EmployeeSortOption.defaultOrder:
          result = 0;
          break;
      }
      return _isDescending ? result : -result;
    });

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Employees',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    DropdownButton<EmployeeSortOption>(
                      value: _sortOption,
                      onChanged:
                          (newValue) => setState(() => _sortOption = newValue!),
                      items: const [
                        DropdownMenuItem(
                          value: EmployeeSortOption.defaultOrder,
                          child: Text('Default'),
                        ),
                        DropdownMenuItem(
                          value: EmployeeSortOption.hours,
                          child: Text('Hours worked'),
                        ),
                        DropdownMenuItem(
                          value: EmployeeSortOption.firstName,
                          child: Text('First name'),
                        ),
                        DropdownMenuItem(
                          value: EmployeeSortOption.lastName,
                          child: Text('Last name'),
                        ),
                        DropdownMenuItem(
                          value: EmployeeSortOption.shiftCount,
                          child: Text('Shift count'),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        _isDescending
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        size: 20,
                      ),
                      tooltip: _isDescending ? "Descending" : "Ascending",
                      onPressed:
                          () => setState(() => _isDescending = !_isDescending),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: employees.length,
              itemBuilder:
                  (context, index) => EmployeeItem(
                    employee: employees[index],
                    from: weekStart,
                    to: weekEnd,
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add employee creation flow
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension on Employee {
  int getWeeklyShiftCount(DateTime from, DateTime to) {
    return weekStatus(from, to).split(',').length;
  }
}
