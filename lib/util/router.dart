import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schedderum/main.dart';

final GoRouter router = GoRouter(
  initialLocation: SplashView.routePath,
  routes: [
    GoRoute(
      path: SplashView.routePath,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashView();
      },
    ),
  ],
);
