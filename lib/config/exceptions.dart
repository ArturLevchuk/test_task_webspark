import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppExceptionAbstract {
  final String message;
  const AppExceptionAbstract(this.message);

  Widget dialogWidget(BuildContext context);

  @override
  String toString() {
    return message;
  }

  @override
  operator == (Object other) => other is AppExceptionAbstract && other.message == message;
  
  @override
  int get hashCode => message.hashCode;
  
}

class AppException extends AppExceptionAbstract {
  const AppException(super.message);

  @override
  Widget dialogWidget(BuildContext context) {
    return AlertDialog(
      title: const Text('Error!'),
      actionsAlignment: MainAxisAlignment.center,
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () {
            context.pop();
          },
          child: const Text(
            'OK',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
