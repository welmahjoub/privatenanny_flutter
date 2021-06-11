import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:private_nanny/page/home.dart';
import 'package:private_nanny/page/loginPage.dart';
import 'package:private_nanny/service/UserService.dart';
import 'package:private_nanny/service/auth.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

void initiateNotification() async {

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.subscribeToTopic('private_nanny');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (UserService.currentUser != null) {
      if (message.data.keys.contains(UserService.currentUser.uid)) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      }
    }
  });

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initiateNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });

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
