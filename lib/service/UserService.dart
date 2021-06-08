import 'dart:async' show Future;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:private_nanny/model/group.dart';
import 'package:private_nanny/model/task.dart';
import 'package:private_nanny/model/utilisateur.dart';

class UserService {
  static Utilisateur currentUser;

  Future<http.Response> updateCurretUser(String uid) async {
    final response = await http.get(
      Uri.parse('https://privatenanny.herokuapp.com/user/' + uid),
    );
    if (response.body != null && response.body != "") {
      currentUser = Utilisateur.fromJson(jsonDecode(response.body));

      final contacts = (jsonDecode(response.body)["contacts"] as List)
          .map((data) => Utilisateur.fromJson(data))
          .toList();

      final groups = (jsonDecode(response.body)["groups"] as List)
          .map((data) => Group.fromJson(data))
          .toList();

      final tasks = (jsonDecode(response.body)["taskList"] as List)
          .map((data) => Task.fromJson(data))
          .toList();

      currentUser.groups = groups;
      currentUser.contacts = contacts;
      currentUser.tasks = tasks;
    }

    return response;
  }

  Future<http.Response> createUser(Utilisateur user) {
    return http.post(
      Uri.parse('https://privatenanny.herokuapp.com/user/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': user.uid,
        'email': user.email,
        'pseudo': user.pseudo,
        'displayName': user.displayName,
        'phoneNo': user.phoneNo
      }),
    );
  }
}
