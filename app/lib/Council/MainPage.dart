import 'package:app/Student/EventDetailsStudent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AddEvent.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Events>>(
        future: fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Events> eventsList = snapshot.data!;

            return ListView.builder(
              itemCount: eventsList.length,
              itemBuilder: (context, index) {
                Events event = eventsList[index];

                // Use Card to display the data in a styled card format
                return Card(
                  elevation: 5, // Add elevation
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Add border radius
                    side: BorderSide(
                      color: Colors.blue, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      event.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Add font weight
                        fontSize: 18, // Add font size
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'starts on : ${event.eventDate.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic, // Add italic style
                          ),
                        ),
                        //changes
                        Text(
                          'ends on: ${event.eventDate.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic, // Add italic style
                          ),
                        ),
                        // Add more details or customize as needed
                      ],
                    ),
                    onTap: () {
                      // Navigate to EventDetails page when a card is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetails(event: event),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


Future<List<Events>> fetchEvents() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('Events')
          .where('status', isEqualTo: true) // Add this line to filter by status
          .get();

      List<Events> eventsList = querySnapshot.docs.map((doc) {
        return Events.fromJson(doc.data(), doc.id);
      }).toList();

      return eventsList;
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }
