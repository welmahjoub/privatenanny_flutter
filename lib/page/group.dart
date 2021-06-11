import 'package:flutter/material.dart';
import 'package:private_nanny/model/group.dart';
import 'package:private_nanny/service/UserService.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/widget/expandable_fab.dart';
import 'creategroup.dart';
import 'widgets.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  AuthService _authService = AuthService();
  UserService back = UserService();

  TextEditingController _textController = TextEditingController();
  List<String> initialList = [];
  List<String> filteredList = [];
  List<Group> groupList = [];

  Widgets widgets = Widgets();

  @override
  void initState() {
    super.initState();

    setState(() {
      groupList =
      UserService.currentUser.groups.toList();
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
          Container(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: TextField(
              decoration: new InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 32.0),
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  //hintText: "Rechercher un groupe",
                  fillColor: Colors.white70),
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
          ),
          Container(
            padding:  const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
           child : ActionButton(
              onPressed: () =>
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupFormPage(
                            group: new Group(),
                            editable: false,
                          ))),
              icon: const Icon(Icons.add_circle_outline_rounded),
            ),
          ),
          if (filteredList.length == 0 && _textController.text.isEmpty)
            Expanded(
                child: ListView.builder(
                    itemCount: initialList.length,
                    itemBuilder: (BuildContext context, index) {
                      return ListTile(
                        title: Text(initialList[index]),
                        onTap: () {
                        Navigator.push(
                        context, MaterialPageRoute(builder: (context) => GroupFormPage(group:groupList[index], editable:true)));
                        },
                      );
                    }
                ),
            )

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
