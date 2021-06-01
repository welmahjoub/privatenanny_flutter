import 'dart:async' show Future;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:private_nanny/model/utilisateur.dart';

class ServiceBackend {
  Future<List<Utilisateur>> getContacts(String id) async {
    final response = await http.get(
      Uri.parse('https://privatenanny.herokuapp.com/user/' + id.toString()),
    );
    final responseJson = (jsonDecode(response.body)["contacts"] as List)
        .map((data) => Utilisateur.fromJson(data))
        .toList();

    print(responseJson.toString());

    return responseJson;
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