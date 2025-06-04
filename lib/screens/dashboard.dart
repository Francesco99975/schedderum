import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const routePath = "/dashboard";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text("Dashboard")),

        body: const TabBarView(children: [Placeholder(), Placeholder()]),
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
