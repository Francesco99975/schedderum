import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/providers/departments.dart';
import 'package:schedderum/providers/theme_provider.dart';
import 'package:schedderum/screens/dashboard.dart';
import 'package:schedderum/screens/error.dart';
import 'package:schedderum/screens/firstuse.dart';
import 'package:schedderum/screens/loading.dart';
import 'package:schedderum/util/router.dart';

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

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  static const routePath = "/";

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(departmentsProvider);

    return d.when(
      data: (data) {
        return data.match(
          (l) {
            return const FirstUseScreen();
          },
          (depts) {
            if (depts.isEmpty) {
              return const FirstUseScreen();
            } else {
              return const DashboardScreen();
            }
          },
        );
      },
      error:
          (error, _) => ErrorScreen(
            errorMessage: "runtime error: $error",
            onRetry: () => ref.refresh(departmentsProvider.future),
          ),
      loading: () => const LoadingScreen(),
    );
  }
}
