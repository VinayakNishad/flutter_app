import 'package:flutter/material.dart';
import 'package:app/Council/AddEvent.dart';

class AdminEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Event Screen'),
      ),
      body: Center(
        child: Text('This is the Admin Event screen.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddEvent screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Create()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
