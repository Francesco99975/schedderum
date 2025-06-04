import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/models/department.dart';
import 'package:schedderum/providers/departments.dart';
import 'package:schedderum/providers/theme_provider.dart';
import 'package:schedderum/screens/dashboard.dart';
import 'package:schedderum/screens/firstuse.dart';
import 'package:schedderum/util/router.dart';
import 'package:schedderum/widget/async_provider_wrapper.dart';
import 'package:fpdart/fpdart.dart' as fp;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: Schedder()));
}

class Schedder extends ConsumerWidget {
  const Schedder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themexProvider);
    return MaterialApp.router(
      title: 'Schedder',
      theme: theme.current,
      routerConfig: router,
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  static const routePath = "/";

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncProviderWrapper<List<Department>>(
      provider: departmentsProvider,
      future: departmentsProvider.future,
      errorOverride: const fp.Option.of(FirstUseScreen()),
      render: (user) {
        return const DashboardScreen();
      },
    );
  }
}
