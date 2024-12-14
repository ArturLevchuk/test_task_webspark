import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_task_webspark/api/models/completed_task_model.dart';
import 'package:test_task_webspark/config/routes.dart';

class ResultListPage extends StatelessWidget {
  const ResultListPage({super.key, required this.completedTasks});
  final List<CompletedTask> completedTasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result list screen'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.pushNamed(RoutesNames.preview,
                  extra: completedTasks[index]);
            },
            child: ListTile(
              title: Text(
                completedTasks[index].toJson()["result"]["path"],
                textAlign: TextAlign.center,
              ),
              shape: LinearBorder.bottom(
                side: const BorderSide(color: Colors.grey, width: 1),
              ),
            ),
          );
        },
        itemCount: completedTasks.length,
      ),
    );
  }
}
