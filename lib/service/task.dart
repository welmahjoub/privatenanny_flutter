
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:private_nanny/model/task.dart';

class TaskService {
  Future<http.Response> createTask(Task task) {
    if(task.dateTime == null){
      task.dateTime = new DateTime.now();
    }
    return http.post(
      Uri.parse('https://privatenanny.herokuapp.com/task/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson())
    );
  }

  Future<http.Response> updateTask(Task task) {
    return http.put(
        Uri.parse('https://privatenanny.herokuapp.com/task/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(task.toJson())
    );
  }
}