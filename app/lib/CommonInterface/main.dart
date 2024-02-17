import 'package:app/Student/loginAsStudent.dart';
import 'package:app/CommonInterface/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCqRGcCaghKQGjHd28aydCb0SdIcQ235uo',
              appId: "1:1069710914902:android:db189317ad0b128acb12f7",
              messagingSenderId: "1069710914902",
              projectId: "applogin-4c8bd"))
      : await Firebase.initializeApp();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: SplashScreen(),
    );
  }
}
