import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:private_nanny/model/group.dart';

class GroupService {
  Future<http.Response> createGroup(Group group) {
    return http.post(
        Uri.parse('https://privatenanny.herokuapp.com/group/saveGroup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(group.toJson())
    );
  }

  Future<http.Response> updateGroup(Group group) {
    return http.put(
        Uri.parse('https://privatenanny.herokuapp.com/group/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(group.toJson())
    );
  }
}