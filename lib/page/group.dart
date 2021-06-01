import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/page/login.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../main.dart';
import 'contact.dart';
import 'home.dart';
import 'widgets.dart';


class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  AuthService _authService = AuthService();

  TextEditingController _textController = TextEditingController();
  List<String> initialList = ["Maison Papa", "Travail", "Maison Maman", "Ecole"];
  List<String> filteredList = List();

  Widgets widgets = Widgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgets.appBar(context, "Groupes"),
      drawer: widgets.drawer(context, _authService),
      body: Column(
          children: <Widget>[
            TextField(
              controller: _textController,
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  filteredList = initialList
                      .where((element) => element.toLowerCase().contains(text))
                      .toList();
                });
              },
            ),
            if (filteredList.length == 0 && _textController.text.isEmpty)
              Expanded(
                  child: ListView.builder(
                      itemCount: initialList.length,
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          height: 50,
                          child: Text(initialList[index]),
                        );
                      }))
            else if (filteredList.length==0 && _textController.text.isNotEmpty)
              Expanded(
                child: Container(
                  child: Text('Aucune donnée'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (BuildContext context, index) {
                      return Container(
                        height: 50,
                        child: Text(filteredList[index]),
                      );
                    }),
              ),
          ],
        ),);
  }


}

