import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_task_webspark/api/models/completed_task_model.dart';
import 'package:test_task_webspark/api/models/task_model.dart';
import 'package:test_task_webspark/config/routes.dart';
import 'package:test_task_webspark/pages/home_page.dart';
import 'package:test_task_webspark/pages/preview_page.dart';
import 'package:test_task_webspark/pages/process_page.dart';
import 'package:test_task_webspark/pages/result_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final goRouterConfig = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: "/",
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          name: RoutesNames.process,
          path: "/${RoutesNames.process}",
          builder: (context, state) =>
              ProcessPage(tasks: state.extra as List<Task>),
        ),
        GoRoute(
          name: RoutesNames.results,
          path: "/${RoutesNames.results}",
          builder: (context, state) => ResultListPage(
            completedTasks: state.extra as List<CompletedTask>,
          ),
          routes: [
            GoRoute(
              name: RoutesNames.preview,
              path: "/${RoutesNames.preview}",
              builder: (context, state) => PreviewPage(
                  completedTask: state.extra as CompletedTask,
                  ),
            ),
          ],
        ),
      ],
    ),
  ],
);
