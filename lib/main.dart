import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_task_webspark/config/router.dart';
import 'package:test_task_webspark/utils/error_catcher.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      final catcher = ErrorCatcher();
      catcher.showDialogForError(details.exception);
    };
    runApp(const MyApp());
  }, (error, stack) {
    final catcher = ErrorCatcher();
    catcher.showDialogForError(error);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.blue,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      routerConfig: goRouterConfig,
    );
  }
}
