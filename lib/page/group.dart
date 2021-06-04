import 'package:flutter/material.dart';
import 'package:private_nanny/service/UserService.dart';
import 'package:private_nanny/service/auth.dart';
import 'widgets.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  AuthService _authService = AuthService();
  UserService back = UserService();

  TextEditingController _textController = TextEditingController();
  List<String> initialList = List();
  List<String> filteredList = List();

  Widgets widgets = Widgets();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      initialList =
          UserService.currentUser.groups.map((e) => e.groupName).toList();
    });

    // back
    //     .getContacts(_authService.auth.currentUser.uid)
    //     .then((value) => setState(() {
    //           initialList = value.map((e) => e.displayName).toList();
    //         }));
  }

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
          else if (filteredList.length == 0 && _textController.text.isNotEmpty)
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
      ),
    );
  }
}
