import 'dart:async' show Future;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:private_nanny/model/group.dart';
import 'package:private_nanny/model/utilisateur.dart';

class UserService {
  static Utilisateur currentUser;

  void updateCurretUser(String uid) async {
    final response = await http.get(
      Uri.parse('https://privatenanny.herokuapp.com/user/' + uid),
    );
    print(jsonDecode(response.body).toString());

    currentUser = Utilisateur.fromJson(jsonDecode(response.body));

    final contacts = (jsonDecode(response.body)["contacts"] as List)
        .map((data) => Utilisateur.fromJson(data))
        .toList();

    final groups = (jsonDecode(response.body)["groups"] as List)
        .map((data) => Group.fromJson(data))
        .toList();
    currentUser.groups = groups;
    currentUser.contacts = contacts;
  }

  Future<http.Response> createUser(Utilisateur user) {
    return http.post(
      Uri.parse('https://privatenanny.herokuapp.com/user/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': user.email,
        'pseudo': user.pseudo,
        'displayName': user.displayName,
        'phoneNo': user.phoneNo
      }),
    );
  }
}
