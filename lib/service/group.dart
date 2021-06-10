import 'dart:convert';

import 'package:private_nanny/model/group.dart';
import 'package:http/http.dart' as http;

class GroupService {
  Future<http.Response> saveGroup(Group group) {
    return http.put(
        Uri.parse('https://privatenanny.herokuapp.com/group/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(group.toJson())
    );
  }
}