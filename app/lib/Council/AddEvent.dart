import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final TextEditingController controllerEventName = TextEditingController();
  final TextEditingController controllerDescribe = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  TextEditingController eventdateController = TextEditingController();
  TextEditingController eventendController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 32),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: controllerEventName,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: "Event Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: controllerDescribe,
                maxLines: 5,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, eventdateController),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: eventdateController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Select Date',
                            labelText: 'Event Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, eventendController),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: eventendController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Select Date',
                            labelText: 'Event End Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Change the button color
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          7
                      )
                  ),
                ),
                onPressed: () async {
                  final user = Events(
                    name: controllerEventName.text,
                    description: controllerDescribe.text,
                    eventDate: selectedDate,
                    eventEndDate: selectedEndDate,
                    status: false,
                    id: '',
                  );

                  // Store data in Firebase
                  await createEvents(user);

                  // Show a SnackBar to inform the user that the content has been submitted
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event submitted successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Delay for 2 seconds and then pop the current screen
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pop(context);
                },
                child: const Text('Create',
                style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createEvents(Events user) async {
    final docUser = FirebaseFirestore.instance.collection('Events').doc();
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }
}

class Events {
  String id;
  final String name;
  final String description;
  final DateTime eventDate;
  final DateTime eventEndDate;
  bool status;

  Events({
    required this.id,
    required this.name,
    required this.description,
    required this.eventDate,
    required this.eventEndDate,
    required this.status,
  });

  factory Events.fromJson(Map<String, dynamic> json, String documentId) {
    return Events(
      id: documentId,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      eventDate: json['eventDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['eventDate'])
          : DateTime.now(),
      eventEndDate: json['eventEndDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['eventEndDate'])
          : DateTime.now(),
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'eventDate': eventDate.toUtc().millisecondsSinceEpoch,
      'eventEndDate': eventEndDate.toUtc().millisecondsSinceEpoch,
      'status': status,
    };
  }
}
