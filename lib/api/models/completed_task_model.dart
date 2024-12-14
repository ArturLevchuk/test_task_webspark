import 'package:test_task_webspark/api/models/task_model.dart';
import 'package:test_task_webspark/utils/shortest_path_searcher.dart';

class CompletedTask {
  final Task task;
  final List<Point> shortestPath;

  CompletedTask({required this.task, required this.shortestPath});

  Map<String, dynamic> toJson() {
    return {
      "id": task.id,
      "result": {
        "steps": shortestPath.map(
          (point) {
            return {"x": point.x, "y": point.y};
          },
        ).toList(),
        "path": shortestPath.map((point) => point.toString()).toList().reduce(
              (value, element) => "$value->$element",
            ),
      }
    };
  }
}