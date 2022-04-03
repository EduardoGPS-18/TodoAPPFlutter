import 'dart:convert';

import 'package:http/http.dart';

import '../../models/info/info_model.dart';
import '../../models/task/task_model.dart';
import '../api/get_api_url.dart';

class TaskRepository {
  final Client _client;

  TaskRepository() : _client = Client();

  Future<List<TaskModel>?> getTasksByToken({required String token}) async {
    final url = '$getApiUrl/tasks';

    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
    final tasksJson = await _client.get(Uri.parse(url), headers: headers);
    final tasksMap = jsonDecode(tasksJson.body);

    return (tasksMap as List).map((e) => TaskModel.fromApiMap(e)).toList();
  }

  Future<InfoModel> getTasksInfo({required String token}) async {
    final url = '$getApiUrl/info';

    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
    final infoJson = await _client.get(Uri.parse(url), headers: headers);
    final infoMap = jsonDecode(infoJson.body);

    return InfoModel.fromMap(infoMap as Map<String, dynamic>);
  }

  Future<TaskModel> createTask({
    required String token,
    required String title,
    String? subtitle,
    String? description,
    DateTime? endDate,
    bool? completed,
  }) async {
    final url = '$getApiUrl/task';
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
    final bodyData = {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'end_date': endDate?.toIso8601String(),
      'completed': completed,
    };
    final response = await _client.post(Uri.parse(url), headers: headers, body: jsonEncode(bodyData));
    return TaskModel.fromApiMap(jsonDecode(response.body));
  }

  Future<TaskModel> updateTask({
    required String token,
    required String id,
    required String title,
    String? subtitle,
    String? description,
    DateTime? endDate,
    bool? completed,
  }) async {
    final url = '$getApiUrl/task/$id';
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
    final bodyData = {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'end_date': endDate?.toIso8601String(),
      'completed': completed,
    };
    final response = await _client.put(Uri.parse(url), headers: headers, body: jsonEncode(bodyData));
    return TaskModel.fromApiMap(jsonDecode(response.body));
  }
}
