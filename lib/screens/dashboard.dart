import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/widget/appbar_sliver.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const routePath = "/dashboard";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Week range logic (example: current week Monday to Sunday)
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (context, innerBoxIsScrolled) => [
                  AppHeaderBarSliver(weekStart: weekStart, weekEnd: weekEnd),
                ],
            body: const TabBarView(
              children: [
                Center(child: Text('Schedule View Placeholder')),
                Center(child: Text('People View Placeholder')),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.schedule)),
            Tab(icon: Icon(Icons.people)),
          ],
        ),
      ),
    );
  }
}
