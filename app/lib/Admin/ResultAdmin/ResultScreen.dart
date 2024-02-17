import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('EventResult').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var eventResults = snapshot.data!.docs;

          return ListView.builder(
            itemCount: eventResults.length,
            itemBuilder: (context, index) {
              var data = eventResults[index].data() as Map<String, dynamic>;

              String eventName = data['name'] ?? '';
              String eventDescription = data['description'] ?? '';
              String firstPlace = data['firstPlace'] ?? '';
              String secondPlace = data['secondPlace'] ?? '';
              String thirdPlace = data['thirdPlace'] ?? '';
              Timestamp? eventDate = data['eventDate'];
              Timestamp? eventEndDate = data['eventEndDate'];

              return Card(
                margin: EdgeInsets.all(16),
                color: Colors.blueAccent,  // Add background color
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event Name: $eventName',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,  // Text color
                        ),
                      ),
                      Text(
                        'Event Description: $eventDescription',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'First Place: $firstPlace',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Second Place: $secondPlace',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Third Place: $thirdPlace',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Event Date: ${eventDate?.toDate()}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Event End Date: ${eventEndDate?.toDate()}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
