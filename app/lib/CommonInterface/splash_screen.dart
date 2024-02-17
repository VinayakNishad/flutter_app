import 'dart:async';
import 'package:flutter/material.dart';

import '../Student/loginAsStudent.dart';
import 'interface.dart';

class SplashScreen extends StatefulWidget {
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DropdownMenuApp(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.deepPurpleAccent,
                Colors.purpleAccent
              ]
            )
          ),
          child: Center(
            child: Text("CConnect",style: TextStyle(
              fontSize: 39,color: Colors.white,
              fontWeight: FontWeight.bold,
            ),),
          ),
        )


    );
  }
}




