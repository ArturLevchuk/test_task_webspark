import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_task_webspark/api/models/completed_task_model.dart';
import 'package:test_task_webspark/api/models/task_model.dart';
import 'package:test_task_webspark/api/webspark_api.dart';
import 'package:test_task_webspark/config/routes.dart';
import 'package:test_task_webspark/controllers/gateway_controller.dart';
import 'package:test_task_webspark/shared_widgets/custom_button.dart';
import 'package:test_task_webspark/utils/shortest_path_searcher.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  bool calculatingProcess = true;
  bool sendingResultProcess = false;
  double progress = 0;

  List<CompletedTask> completedTasks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.tasks.isEmpty) {
        throw Exception("No tasks");
      }
      final step = 1 / widget.tasks.length;

      for (int i = 0; i < widget.tasks.length; i++) {
        final task = widget.tasks[i];
        final shortestPathSearcher = ShortestPathSearcher(
            start: task.startPoint, end: task.endPoint, map: task.map);
        final path = shortestPathSearcher.findShortestPath();
        if (path == null) {
          log("No path found for task ${task.id}");
          continue;
        }

        final completedTask = CompletedTask(task: task, shortestPath: path);
        completedTasks.add(completedTask);
        if (mounted) {
          setState(() {
            progress += step;
          });
        }
      }
      if (mounted) {
        setState(() {
          calculatingProcess = false;
          progress = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                calculatingProcess
                    ? "Calculation..."
                    : "All calculations have finished, you can send your results to the server",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text("${progress * 100}%",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: progress,
                ),
              ),
              const Spacer(),
              if (!calculatingProcess)
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      !sendingResultProcess
                          ? CustomButton(
                              onPressed: () async {
                                final GatewayController gatewayController =
                                    GatewayController();
                                final WebsparkApi websparkApi = WebsparkApi(
                                  baseUrl: gatewayController.gatewayUrl,
                                );
                                try {
                                  setState(() {
                                    sendingResultProcess = true;
                                  });
                                  await websparkApi
                                      .sendCompletedTasks(completedTasks);
                                  if (mounted) {
                                    context.pushReplacementNamed(
                                      RoutesNames.results,
                                      extra: completedTasks,
                                    );
                                  }
                                } finally {
                                  setState(() {
                                    sendingResultProcess = false;
                                  });
                                }
                              },
                              text: "Send results to server",
                            )
                          : const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
