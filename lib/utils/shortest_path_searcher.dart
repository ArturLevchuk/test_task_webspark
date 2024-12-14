import 'dart:collection';

class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  @override
  String toString() {
    return '($x,$y)';
  }

  @override
  bool operator ==(Object other) =>
      other is Point && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class ShortestPathSearcher {
  final Point start;
  final Point end;
  // map of allowed movement (symbol '.' is allowed, 'X' is not allowed)
  final List<List<String>> map;

  ShortestPathSearcher({
    required this.start,
    required this.end,
    required this.map,
  });

  // 8 _directions of movement
  final List<Point> _directions = const [
    Point(-1, 0), // up
    Point(1, 0), // down
    Point(0, -1), // left
    Point(0, 1), // right
    Point(-1, -1), // top-left diagonal
    Point(-1, 1), // top-right diagonal
    Point(1, -1), // bottom-left diagonal
    Point(1, 1), // bottom-right diagonal
  ];

  List<Point>? findShortestPath() {
    final rowLength = map.length;
    final columnLength = map[0].length;

    if (!(rowLength > 1 &&
        columnLength > 1 &&
        rowLength < 100 &&
        columnLength < 100)) {
      throw Exception('Invalid map size');
    }

    final visitedCells =
        List.generate(rowLength, (_) => List.filled(columnLength, false));

    final Queue<List<Point>> queue = Queue()..add([start]);
    visitedCells[start.x][start.y] = true;

    while (queue.isNotEmpty) {
      final path = queue.removeFirst();
      final current = path.last;

      if (current.x == end.x && current.y == end.y) {
        return path;
      }

      for (final direction in _directions) {
        final nextX = current.x + direction.x;
        final nextY = current.y + direction.y;

        if (_isValidMove(nextX, nextY, rowLength, columnLength, visitedCells)) {
          visitedCells[nextX][nextY] = true;
          final newPath = List.of(path)..add(Point(nextX, nextY));
          queue.add(newPath);
        }
      }
    }

    return null;
  }

  bool _isValidMove(
      int x, int y, int rows, int cols, List<List<bool>> visitedCells) {
    return x >= 0 &&
        x < rows &&
        y >= 0 &&
        y < cols &&
        map[x][y] == '.' &&
        !visitedCells[x][y];
  }
}
