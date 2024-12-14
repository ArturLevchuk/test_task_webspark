import 'package:flutter/material.dart';
import 'package:test_task_webspark/config/exceptions.dart';
import 'package:test_task_webspark/config/router.dart';

class ErrorCatcher {
  ErrorCatcher._();
  static final _instance = ErrorCatcher._();
  factory ErrorCatcher() => _instance;
  AppExceptionAbstract? _lastException;
  bool _isShowing = false;

  void showDialogForError(dynamic exception) {
    late final AppExceptionAbstract exceptionToShow;
    if (exception is! AppExceptionAbstract) {
      exceptionToShow = AppException(exception.toString());
    } else {
      exceptionToShow = exception;
    }
    if (_lastException == exception && _isShowing) {
      return;
    }
    _isShowing = true;
    showDialog(
      builder: (context) {
        return exceptionToShow.dialogWidget(context);
      },
      context: goRouterConfig.routerDelegate.navigatorKey.currentContext!,
    ).then((value) => _isShowing = false);
  }
}
