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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        ListTile(
          title: Text('Tâches attribuées'),
          onTap: () {
            // Update the state of the app.
            // ...
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        ListTile(
          title: Text('Mes contacts'),
          onTap: () {
            // Update the state of the app.
            // ...
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContactScreen()));
          },
        ),
        ListTile(
          title: Text('Mes groupes'),
          onTap: () {
            // Update the state of the app.
            // ...
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GroupScreen()));
          },
        ),
        ListTile(
          title: Text('Déconnexion'),
          onTap: () {
            _authService.logout();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      ],
    ));
  }
}
