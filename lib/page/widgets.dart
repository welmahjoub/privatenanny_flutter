import 'package:flutter/material.dart';
import 'package:private_nanny/page/contact.dart';
import 'package:private_nanny/page/group.dart';
import 'package:private_nanny/page/home.dart';
import 'package:private_nanny/page/loginPage.dart';
import 'package:private_nanny/page/profile_page.dart';
import 'package:private_nanny/service/auth.dart';

//actions: [Icon(Icons.account_circle_rounded), Container(width: 15)],
class Widgets {
  Widget appBar(BuildContext context, title) {
    return new AppBar(
      title: Text(title),
      centerTitle: true,
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.account_circle_rounded),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PorfilePage()));
          },
        ),
        Container(width: 15)
      ],
    );
  }

  Widget drawer(BuildContext context, AuthService _authService) {
    return new Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Stack(children: <Widget>[
                Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text("Private Nanny",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500))),
              ])),
          Expanded(
              child: ListView(children: <Widget>[
                createDrawerItem( icon: Icons.home, text: 'Accueil', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()))),
                Divider(),
                //createDrawerItem(icon: Icons.task, text: 'Mes tâches', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()))),
                createDrawerItem(icon: Icons.list, text: 'Tâches attribuées', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()))),
                createDrawerItem(icon: Icons.contacts, text: 'Mes contacts', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContactScreen()))),
                //createDrawerItem(icon: Icons.groups, text: 'Mes groupes', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GroupScreen()))),
              ])
          ),
          Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      child: Column(
                        children: <Widget>[
                          Divider(),
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.logout),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("Déconnexion"),
                                )
                              ],
                            ),
                            onTap: () {
                              _authService.logout();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                          ),
                        ],
                      )
                  )
              )
          )
        ],
      ),
    );
  }

  Widget createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
