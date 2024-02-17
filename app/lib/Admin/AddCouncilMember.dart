import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddCouncilMemberDetails.dart';

class AddMember extends StatefulWidget {
  @override
  _AddMember createState() => _AddMember();
}

class _AddMember extends State<AddMember> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email == "" || password == "") {
      // Show an alert box to inform the user
      showAlertDialog(context, "Please fill all the details");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (userCredential.user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMemberDetails()),
          );
          Navigator.pop(context, {'email': email, 'password': password});
        }
      } on FirebaseAuthException catch (ex) {
        // Show an alert box with the FirebaseAuthException message
        showAlertDialog(context, ex.message ?? "An Network error occurred");
      }
    }
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Adding member'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 35, right: 35),
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: _emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: "Email",
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  style: const TextStyle(),
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: "Password",
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CupertinoButton.filled(
                  onPressed: () {
                    register(); // Call the register method here
                  },
                  child: const Text('send mail',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
