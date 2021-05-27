import 'package:flutter/material.dart';

import 'main.dart';
import 'service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.email}) : super(key: key);
  final String email;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Service _userService = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //leading: Icon(Icons.account_circle_rounded),
          //automaticallyImplyLeading: false,
          title: Text("Accueil"),
          centerTitle: true,
          actions: [
            Icon(Icons.account_circle_rounded),
            Container(width: 15)
          ],
        ),
        drawer: Drawer(),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Bonjour " + widget.email),
                TextButton(
                  onPressed: () async {
                    await _userService.logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                      (route) => false,
                    );
              },
              child: Text('logout'),
            ),
          ],
        )));
  }
}
