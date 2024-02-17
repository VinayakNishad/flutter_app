import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UpdateLeaderBoard.dart'; // Import your LeaderBoardUpdate screen
import 'EditLeaderboardEntry.dart'; // Import your EditLeaderboardEntry screen

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('LeaderBoard')
            .orderBy('score', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var leaderboardData = snapshot.data!.docs;

          return ListView.builder(
            itemCount: leaderboardData.length,
            itemBuilder: (context, index) {
              var data = leaderboardData[index].data() as Map<String, dynamic>;
              String teamName = data['teamName'];
              int score = data['score'];
              int rank = index + 1; // Assuming 1-based ranking

              return AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      rank.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('$teamName'),
                  subtitle: Text('Score: $score'),
                  onTap: () {
                    // Navigate to EditLeaderboardEntry screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditLeaderboardEntry(
                          teamName: teamName,
                          initialScore: score,
                          documentId: leaderboardData[index].id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to LeaderBoardUpdate screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LeaderBoardUpdate()),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
