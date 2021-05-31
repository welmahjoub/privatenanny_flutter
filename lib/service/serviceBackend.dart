import 'dart:async' show Future;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:private_nanny/model/utilisateur.dart';

class ServiceBackend{


  Future<List<Utilisateur>> getContacts(int id) async{

    final response = await http.get(
      Uri.parse('https://privatenanny.herokuapp.com/user/'+ id.toString() ),
    );
    final responseJson = (jsonDecode(response.body)["contacts"] as List).map((data) => Utilisateur.fromJson(data)).toList();

    print(responseJson.toString());

    return responseJson;


  }

}




