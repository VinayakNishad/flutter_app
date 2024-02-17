import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Council/AddEvent.dart';
import 'AdminHomePage.dart';

class ShowContentInListFormat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Events>>(
      // Replace with your method to fetch data from Firestore
      future: fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Display a loading indicator while data is being fetched
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Events> eventsList = snapshot.data!;

          return ListView.builder(
            itemCount: eventsList.length,
            itemBuilder: (context, index) {
              Events event = eventsList[index];

              return Card(
                elevation: 3,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('Event Name: ${event.name}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('Event Description: ${event.description}'),
                          Text('Event Date: ${event.eventDate.toLocal().toString().split(' ')[0]}'),
                          // Add more details or customize as needed
                        ],
                      ),
                      onTap: () {
                        // Handle onTap if needed
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Handle "Approve" button click
                            approveEvent(event);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Event approved successfully!'),
                              ),
                            );
                          },
                          icon: Icon(Icons.thumb_up, color: Colors.white),
                          label: Text('Approve'),
                          style: ElevatedButton.styleFrom(primary: Colors.green),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Handle "Reject" button click
                            rejectEvent(event);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Event rejected successfully!'),
                              ),
                            );
                          },
                          icon: Icon(Icons.thumb_down, color: Colors.white),
                          label: Text('Reject'),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
