import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditLeaderboardEntry extends StatefulWidget {
  final String teamName;
  final int initialScore;
  final String documentId;

  EditLeaderboardEntry({
    required this.teamName,
    required this.initialScore,
    required this.documentId,
  });

  @override
  _EditLeaderboardEntryState createState() => _EditLeaderboardEntryState();
}

class _EditLeaderboardEntryState extends State<EditLeaderboardEntry> {
  late TextEditingController _teamNameController;
  late TextEditingController _scoreController;

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController(text: widget.teamName);
    _scoreController = TextEditingController(text: widget.initialScore.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Leaderboard Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _teamNameController,
              decoration: InputDecoration(labelText: 'Team Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _scoreController,
              decoration: InputDecoration(labelText: 'Score'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateLeaderboardEntry();
              },
              child: Text('Update Entry'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateLeaderboardEntry() {
    String newTeamName = _teamNameController.text.trim();
    int newScore = int.parse(_scoreController.text.trim());

    FirebaseFirestore.instance
        .collection('LeaderBoard')
        .doc(widget.documentId)
        .update({
      'teamName': newTeamName,
      'score': newScore,
    });

    Navigator.pop(context); // Return to the previous screen
  }
}
