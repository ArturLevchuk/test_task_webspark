import 'package:test_task_webspark/utils/shortest_path_searcher.dart';

class Task {
  final String id;
  final Point startPoint;
  final Point endPoint;
  final List<List<String>> map;

  Task({required this.id, required this.startPoint, required this.endPoint, required this.map});

  @override
  String toString() {
    return 'Task{id: $id, startPoint: $startPoint, endPoint: $endPoint, map: $map}';
  }
}
