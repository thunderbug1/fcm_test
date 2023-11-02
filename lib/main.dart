import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Messaging Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _message = '';

  Future<void> initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      try {
        String? token = await messaging.getToken(
            vapidKey:
                "BIBzlvxnpzV-zdv1G918P9GZKtwJogHx3GAz0Pcc8W2mPIXJFcBKPU19EsgaQdfdd9xoWKBxANAvk7ZmYlkkCN4");
        setState(() {
          _message = 'Firebase Messaging Token: $token';
          print(_message);
        });
      } catch (error) {
        setState(() {
          _message = 'Error getting token: $error';
          print(_message);
        });
      }
    } else {
      setState(() {
        _message = 'User declined or has not accepted permission';
        print(_message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Messaging Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Initialize Firebase Messaging'),
              onPressed: initializeFirebaseMessaging,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(_message),
            ),
          ],
        ),
      ),
    );
  }
}
