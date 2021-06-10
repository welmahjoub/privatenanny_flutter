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
    currentUser = parseFromJson(jsonDecode(response.body));

    return response;
  }

  Future<Utilisateur> findUserByEmail(String email) async {
    final response = await http.get(
      Uri.parse(
          'https://privatenanny.herokuapp.com/user/findUserByEmail' + email),
    );
    Utilisateur user = parseFromJson(jsonDecode(response.body));

    return user;
  }

  Future<List<Utilisateur>> getAllUser() async {
    final response = await http.get(
      Uri.parse('https://privatenanny.herokuapp.com/user/'),
    );
    Iterable l = json.decode(response.body);
    List<Utilisateur> users =
        List<Utilisateur>.from(l.map((model) => parseFromJson(model)));

    return users;
  }

  Utilisateur parseFromJson(response) {
    Utilisateur user;
    if (response != null && response != "") {
      user = Utilisateur.fromJson(response);

      final contacts = (response["contacts"] as List)
          .map((data) => Utilisateur.fromJson(data))
          .toList();

      final groups = (response["groups"] as List)
          .map((data) => Group.fromJson(data))
          .toList();

      final tasks = (response["taskList"] as List)
          .map((data) => Task.fromJson(data))
          .toList();

      user.groups = groups;
      user.contacts = contacts;
      user.tasks = tasks;
    }
    return user;
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

  Future<http.Response> updateUser(Utilisateur user) {
    return http.put(
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

  Future<http.Response> addUserToContact(String uid, Utilisateur contact) {
    return http.put(
      Uri.parse(
          'https://privatenanny.herokuapp.com/user/' + uid + '/contacts/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': contact.uid,
      }),
    );
  }

  Future<http.Response> addUserToGroup(String uid, Group group) {
    return http.put(
      Uri.parse('https://privatenanny.herokuapp.com/user/' + uid + '/groups/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'groupName': group.groupName,
      }),
    );
  }
}
