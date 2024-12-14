import 'package:flutter/material.dart';
import 'package:test_task_webspark/api/models/completed_task_model.dart';
import 'package:test_task_webspark/utils/shortest_path_searcher.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key, required this.completedTask});
  final CompletedTask completedTask;

  Color _getPointColor(Point point) {
    if (_getLockedPoints.contains(point)) {
      return const Color(0xff000000);
    } else if (completedTask.task.startPoint == point) {
      return const Color(0xff64FFDA);
    } else if (completedTask.task.endPoint == point) {
      return const Color(0xff009688);
    } else if (completedTask.shortestPath.contains(point)) {
      return const Color(0xff4CAF50);
    } else {
      return Colors.white;
    }
  }

  List<Point> get _getLockedPoints {
    final List<Point> lockedPoints = [];
    for (var i = 0; i < completedTask.task.map.length; i++) {
      final row = completedTask.task.map[i];
      for (var y = 0; y < row.length; y++) {
        if (row[y] != '.') {
          lockedPoints.add(Point(i, y));
        }
      }
    }
    return lockedPoints;
  }

  @override
  Widget build(BuildContext context) {
    final rowLength = completedTask.task.map.length;
    final columnLength = completedTask.task.map[0].length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview screen'),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength,
              ),
              itemBuilder: (context, index) {
                final gridPointX = index ~/ rowLength;
                final gridPointY = index % columnLength;
                final Point gridPoint = Point(
                  gridPointY,
                  gridPointX,
                ); // inverted for grid format
                final backgroundColor = _getPointColor(gridPoint);

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    color: backgroundColor,
                  ),
                  child: Center(
                    child: Text(
                      gridPoint.toString(),
                      style: TextStyle(
                        color: backgroundColor == Colors.black
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
              itemCount: rowLength * columnLength,
            ),
          ),
          const SizedBox(height: 20),
          Text(completedTask.toJson()["result"]["path"],
              style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
