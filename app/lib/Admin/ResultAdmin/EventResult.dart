import 'package:app/Admin/ResultAdmin/ResultScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventResult extends StatefulWidget {
  @override
  _EventResultState createState() => _EventResultState();
}

class _EventResultState extends State<EventResult> {
  TextEditingController nameController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  TextEditingController thirdController = TextEditingController();
  TextEditingController eventdateController = TextEditingController();
  TextEditingController eventendController = TextEditingController();
  final CollectionReference eventCollection =
  FirebaseFirestore.instance.collection('EventResult');

  DateTime selectedDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller) async {
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

  Future<void> _selectEndDate(BuildContext context,
      TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Result'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Name',
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.event),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("Event date: "),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectEndDate(context, eventdateController),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: eventdateController,
                          decoration: InputDecoration(
                            hintText: 'Select Date',
                            labelText: 'Event  Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),


              SizedBox(height: 20),
              Row(
                children: [
                  Text("Event end date: "),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectEndDate(context, eventendController),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: eventendController,
                          decoration: InputDecoration(
                            hintText: 'Select Date',
                            labelText: 'Event End Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: desController,
                maxLines: 5,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Enter Description',
                  labelText: 'Event Description',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.description),
                ),
              ),
              SizedBox(height: 20),
              Text("First place: "),
              TextField(
                controller: firstController,
                decoration: InputDecoration(
                  hintText: 'Team/Participant Name',
                  labelText: 'First Place',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.looks_one),
                ),
              ),
              SizedBox(height: 20),
              Text("Second place: "),
              TextField(
                controller: secondController,
                decoration: InputDecoration(
                  hintText: 'Team/Participant Name',
                  labelText: 'Second Place',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.looks_two),
                ),
              ),
              SizedBox(height: 20),
              Text("Third place: "),
              TextField(
                controller: thirdController,
                decoration: InputDecoration(
                  hintText: 'Team/Participant Name',
                  labelText: 'Third Place',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.looks_3),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Call the function to store data in Firestore
                    addEventData(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // background color
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to store data in Firestore
  Future<void> addEventData(BuildContext context) async {
    try {
      String eventName = nameController.text;
      String eventDescription = desController.text;
      String firstPlace = firstController.text;
      String secondPlace = secondController.text;
      String thirdPlace = thirdController.text;

      // Validate that all fields are filled
      if (eventName.isEmpty ||
          eventDescription.isEmpty ||
          firstPlace.isEmpty ||
          secondPlace.isEmpty ||
          thirdPlace.isEmpty ||
          selectedDate == null ||
          selectedEndDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all fields'),
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }

      Timestamp eventDate = Timestamp.fromDate(selectedDate);
      Timestamp eventEndDate = Timestamp.fromDate(selectedEndDate);

      await eventCollection.add({
        'name': eventName,
        'description': eventDescription,
        'firstPlace': firstPlace,
        'secondPlace': secondPlace,
        'thirdPlace': thirdPlace,
        'eventDate': eventDate,
        'eventEndDate': eventEndDate,
      });

      // Show a SnackBar message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Submitted successfully'),
          duration: Duration(seconds: 5),
        ),
      );

      // Pop the current screen from the navigation stack
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(),
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
