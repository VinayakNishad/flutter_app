import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AdminHomePage.dart';

class AddMemberDetails extends StatefulWidget {
  @override
  _AddMemberDetails createState() => _AddMemberDetails();
}

class _AddMemberDetails extends State<AddMemberDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  Future<void> addMember() async {
    String memberName = _nameController.text.trim();
    String position = _positionController.text.trim();

    if (memberName == "" || position == "") {
      log("Please fill all the fields");
    } else {
      try {
        // Show an alert box to inform the user
        showAlertDialog(context, "Adding Council Member...");

        await FirebaseFirestore.instance.collection('CouncilMembers').add({
          'name': memberName,
          'position': position,
        });

        // Optionally, you can navigate back or perform any other action after adding the member
        Navigator.pop(context); // Close the alert box
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminHome()),
        );
      } catch (error) {
        log("Error adding member: $error");
        Navigator.pop(context); // Close the alert box in case of an error
      }
    }
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 15),
              Text(message),
            ],
          ),
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: "Member name",
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  style: const TextStyle(),
                  controller: _positionController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: "Position",
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CupertinoButton.filled(
                  onPressed: () {
                    addMember(); // Call the addMember method here
                  },
                  child: const Text('Add member',
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
