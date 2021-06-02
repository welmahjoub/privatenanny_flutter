import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/page/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false, // deleted debug bar in AppBar Widget
        title: 'private nanny',
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: LoginPage());
  }
}
