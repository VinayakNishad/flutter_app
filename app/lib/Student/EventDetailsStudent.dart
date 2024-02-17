import 'package:flutter/material.dart';
import 'package:app/Council/MainPage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Council/AddEvent.dart';

class EventDetails extends StatefulWidget {
  final Events event;

  EventDetails({required this.event});

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _colorAnimation = ColorTween(
      begin: Colors.blue, // Starting color
      end: Colors.green, // Ending color
    ).animate(_controller);

    _controller.repeat(reverse: true); // Repeat the color animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event : ${widget.event.name}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text('Event Description: ${widget.event.description}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              Text('Event Date: ${widget.event.eventDate.toLocal().toString().split(' ')[0]}'),
              // Add more details or customize as needed

              // Add Register Button with color animation
              SizedBox(height: 16.0), // Adjust the spacing as needed
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) {
                  return ElevatedButton(
                    onPressed: () {
                      launch('https://docs.google.com/forms/d/e/1FAIpQLSe1RklmDq1xwZdBDM8akVvFm2v7oRbyPM5A08Zb--_OfDbFdA/viewform?usp=sf_link');
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: _colorAnimation.value, // Use the animated color
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
