import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:private_nanny/model/task.dart';

class TaskService {
  Future<http.Response> createTask(Task task) {
    if (task.dateTime == null) {
      task.dateTime = new DateTime.now();
    }
    return http.post(Uri.parse('https://privatenanny.herokuapp.com/task/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(task.toJson()));
  }

  Future<http.Response> updateTask(Task task) {
    return http.put(Uri.parse('https://privatenanny.herokuapp.com/task/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(task.toJson()));
  }

  Future<List<Task>> getAllTaskByReceiver(String uid) async {
    final response = await http.get(
      Uri.parse(
          'https://privatenanny.herokuapp.com/task/findTasksByReceiver/$uid'),
    );
    print(response.body);
    if (response.body != null && response.body != "") {
      Iterable l = json.decode(response.body);
      List<Task> task = List<Task>.from(l.map((model) => Task.fromJson(model)));
      return task;
    }
    return [];
  }
}
