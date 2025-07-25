import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/models/department.dart';

import 'package:schedderum/screens/employees.dart';
import 'package:schedderum/screens/schedule.dart';
import 'package:schedderum/widget/appbar_sliver.dart';

class DashboardScreen extends ConsumerWidget {
  static const routePath = "/dashboard";

  final Department currentDepartment;
  final DateTime activeWeek;

  const DashboardScreen({
    super.key,
    required this.currentDepartment,
    required this.activeWeek,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (context, innerBoxIsScrolled) => [
                  AppHeaderBarSliver(
                    selectedDepartment: currentDepartment,
                    weekStart: activeWeek,
                  ),
                ],
            body: TabBarView(
              children: [
                ScheduleScreen(
                  currentDepartment: currentDepartment,
                  weekStart: activeWeek,
                ),
                EmployeesScreen(
                  currentDepartment: currentDepartment,
                  weekStart: activeWeek,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.schedule)),
              Tab(icon: Icon(Icons.people)),
            ],
          ),
        ),
      ),
    );
  }
}
