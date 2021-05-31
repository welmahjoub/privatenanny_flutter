import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../main.dart';
import 'contact.dart';
import 'home.dart';


class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  AuthService _authService = AuthService();

  TextEditingController _textController = TextEditingController();
  List<String> initialList = ["Maison Papa", "Travail", "Maison Maman", "Ecole"];
  List<String> filteredList = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes groupes"),
        centerTitle: true,
        actions: [
          Icon(Icons.account_circle_rounded),
          Container(width: 15)
        ],
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Menu'),
              ),
              ListTile(
                title: Text('Mes tâches'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.push(context, MaterialPageRoute( builder: (context) => HomeScreen()));
                },
              ),
              ListTile(
                title: Text('Tâches attribuées'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.push(context, MaterialPageRoute( builder: (context) => HomeScreen()));

                },
              ),
              ListTile(
                title: Text('Mes contacts'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.push(context, MaterialPageRoute( builder: (context) => ContactScreen()));
                },
              ),
              ListTile(
                title: Text('Mes groupes'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.push(context, MaterialPageRoute( builder: (context) => GroupScreen()));
                },
              ),
            ],
          )
      ),

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

