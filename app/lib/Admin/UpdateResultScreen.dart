import 'package:flutter/material.dart';
class AdminScreen extends StatefulWidget {
  final Function(String, String) onAddEvent;

  const AdminScreen({Key? key, required this.onAddEvent}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventResultController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: eventNameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: eventResultController,
              decoration: const InputDecoration(labelText: 'Event Result'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add the event to the Setting screen
                widget.onAddEvent(
                  eventNameController.text,
                  eventResultController.text,
                );

                // Clear the text controllers after adding the event
                eventNameController.clear();
                eventResultController.clear();
              },
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}