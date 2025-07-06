import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schedderum/main.dart';
import 'package:schedderum/screens/add_extensive_records_form.dart';
import 'package:schedderum/screens/error.dart';

final GoRouter router = GoRouter(
  initialLocation: SplashView.routePath,
  routes: [
    GoRoute(
      path: SplashView.routePath,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashView();
      },
    ),
    GoRoute(
      path: AddExtensiveRecordFormScreen.routePath,
      builder: (context, state) {
        final departmentId = state.uri.queryParameters['departmentId'];
        if (departmentId == null) {
          return ErrorScreen(
            errorMessage: "Missing departmentId",
            onRetry: () {},
          );
        }

        return AddExtensiveRecordFormScreen(departmentId: departmentId);
      },
    ),
  ],
);
