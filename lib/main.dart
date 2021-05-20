import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/Home.dart';
import 'package:private_nanny/service.dart';
import 'package:private_nanny/user.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Service _userService = Service();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false, // deleted debug bar in AppBar Widget
      title: 'private nanny',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      // home: StreamBuilder(
      //   stream: _userService.user,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.active) {
      //       if (snapshot.hasData) {
      //         return HomeScreen();
      //       }

      //       return LoginPage();
      //     }

      //     return SafeArea(
      //       child: Scaffold(
      //         body: Center(
      //           child: Text('Loading...'),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
