import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'LeaderBoardScreen.dart';

class LeaderBoardUpdate extends StatefulWidget {
  @override
  _LeaderBoardUpdateState createState() => _LeaderBoardUpdateState();
}

class _LeaderBoardUpdateState extends State<LeaderBoardUpdate> {
  TextEditingController nameController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  final CollectionReference leaderBoardCollection =
  FirebaseFirestore.instance.collection('LeaderBoard');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LeaderBoard Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.leaderboard,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Team Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: scoreController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Score',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.score),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Call the function to store data in Firestore
                addLeaderBoardData(context);
              },
              icon: Icon(Icons.send),
              label: Text('Submit'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to store data in Firestore
  Future<void> addLeaderBoardData(BuildContext context) async {
    try {
      String teamName = nameController.text;
      int score = int.parse(scoreController.text);

      await leaderBoardCollection.add({
        'teamName': teamName,
        'score': score,
      });

      // Show a SnackBar message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Submitted successfully'),
          duration: Duration(seconds: 3),
        ),
      );

      // You can also navigate to another screen after submission
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeaderboardScreen(),
        ),
      );
    } catch (e) {
      print('Error submitting data: $e');
      // Handle the error as needed, for example, show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting data'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
