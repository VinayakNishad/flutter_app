import 'dart:io';

import 'package:app/Council/AddEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ShowContent extends StatelessWidget {
  final Events event;
  final File? pdfFile;
  const ShowContent({
    Key? key,
    required this.event,
    this.pdfFile,

  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(''),
    ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dance.jpg'), // Change to your background image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add some styling to your data
                Container(
                  padding: EdgeInsets.all(80),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8), // Adjust opacity as needed
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Event Name: ${event.name}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Event Date: ${event.eventDate.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Description: ${event.description}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      if (pdfFile != null)
                        Text(
                          'Selected PDF: ${pdfFile!.path}',
                          style: TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Add approve and reject buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 140, // Set a fixed width for the container
                      child: ElevatedButton(
                        onPressed: () {
                          // Update status to true (approved) in Firebase
                          updateStatus(true);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // Set green color for the approve button
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, color: Colors.white), // Add approve icon
                            SizedBox(width: 6),
                            Text('Approve', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 150, // Set a fixed width for the container
                      child: ElevatedButton(
                        onPressed: () {
                          // Update status to false (rejected) in Firebase
                          updateStatus(false);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Set red color for the reject button
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, color: Colors.white), // Add reject icon
                            SizedBox(width: 6),
                            Text('Reject', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateStatus(bool status) async {
    try {
      // Update the 'status' field in Firebase
      await FirebaseFirestore.instance
          .collection('Event')
          .doc(event.id)
          .update({'status': status});
      print('Updated');

      if (status) {
        // If the status is true (approved), you may perform additional actions here
        // For example, update other fields or trigger some events
      } else {
        // If the status is false (rejected), delete the document
        await FirebaseFirestore.instance.collection('Event').doc(event.id).delete();
        print('Event deleted');
      }

    } catch (e) {
      print('Error updating status: $e');
      // Handle error as needed
    }
  }
}
