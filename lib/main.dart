import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/page/home.dart';
import 'package:private_nanny/page/loginPage.dart';
import 'package:private_nanny/service/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // deleted debug bar in AppBar Widget
        title: 'private nanny',
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: LoginPage());

    // if (auth.auth.currentUser != null) {
    //   return MaterialApp(
    //       debugShowCheckedModeBanner:
    //           false, // deleted debug bar in AppBar Widget
    //       title: 'private nanny',
    //       theme: new ThemeData(primarySwatch: Colors.blue),
    //       home: LoginPage());
    // } else {
    //   return MaterialApp(
    //       debugShowCheckedModeBanner:
    //           false, // deleted debug bar in AppBar Widget
    //       title: 'private nanny',
    //       theme: new ThemeData(primarySwatch: Colors.blue),
    //       home: HomeScreen());
    // }
  }
}
