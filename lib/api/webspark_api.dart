import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:test_task_webspark/api/models/completed_task_model.dart';
import 'package:test_task_webspark/api/models/task_model.dart';
import 'package:test_task_webspark/utils/shortest_path_searcher.dart';

class WebsparkApi {
  final String _baseUrl;
  late final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  WebsparkApi({required String baseUrl}) : _baseUrl = baseUrl;

  Future<List<Task>> getTasks() async {
    try {
      final response = await _dio.get('');
      final responseData = response.data;
      if (responseData?["error"] == true) {
        throw Exception(responseData["message"] ?? "Something went wrong!");
      }

      return List<Map<String, dynamic>>.from(responseData["data"]).map(
        (task) {
          return Task(
            id: task["id"],
            startPoint: Point(
              task["start"]["x"],
              task["start"]["y"],
            ),
            endPoint: Point(
              task["end"]["x"],
              task["end"]["y"],
            ),
            map: List<String>.from(task["field"])
                .map((row) => row.split(''))
                .toList(),
          );
        },
      ).toList();
    } catch (err) {
      log(err.toString());
      throw Exception("Something went wrong!");
    }
  }

  Future<void> sendCompletedTasks(List<CompletedTask> completedTasks) async {
    try {
      final response = await _dio.post('',
          data: completedTasks.map((task) => task.toJson()).toList());
      final responseData = response.data;
      if (responseData?["error"] == true) {
        throw Exception(responseData["message"]  ?? "Something went wrong!");
      }
    } catch (err) {
      log(err.toString());
      throw Exception("Something went wrong!");
    }
  }
}
