import 'package:flutter/material.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/page/create_contact_page.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/service/UserService.dart';
import 'widgets.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  AuthService _authService = AuthService();

  TextEditingController _textController = TextEditingController();
  List<String> initialList = List();
  List<String> filteredList = List();
  List<Utilisateur> contactList;

  UserService back = UserService();

  Widgets widgets = Widgets();

  @override
  void initState() {
    super.initState();
    print(UserService.currentUser);

    setState(() {
      if (UserService.currentUser != null) {
        initialList =
            UserService.currentUser.contacts.map((e) => e.displayName).toList();
      } else {
        initialList = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgets.appBar(context, "Contacts"),
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
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  //hintText: "Rechercher un contact",
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
          if (filteredList.length == 0 && _textController.text.isEmpty)
            Expanded(
                child: ListView.builder(
                    itemCount: initialList.length,
                    itemBuilder: (BuildContext context, index) {
                      return ListTile(
                        title: Text(initialList[index]),
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
      bottomNavigationBar: BottomSection(),
    );
  }
}

class BottomSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return BottomNavigationBar(
    //   backgroundColor: Colors.blue,
    //   showSelectedLabels: false,
    //   showUnselectedLabels: false,
    //   items: [
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.arrow_back_ios_rounded,
    //         color: Colors.white,
    //       ),
    //       label: '',
    //     ),
    //     BottomNavigationBarItem(
    //         icon: Text(
    //           "Nouveau contact",
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             color: Colors.white,
    //             fontSize: 15,
    //             fontWeight: FontWeight.w500,
    //           ),
    //         ),
    //         label: ''),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.add_circle,
    //         color: Colors.white,
    //       ),
    //       label: '',
    //     ),
    //   ],
    // );
    return BottomNavigationBar(
      backgroundColor: Colors.blue,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Text(
              "Nouveau contact",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            label: ''),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, color: Colors.white),
          label: '',
        ),
      ],
      onTap: (ValueKey) => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => (ContactFormPage())))
      },
    );
  }
}
