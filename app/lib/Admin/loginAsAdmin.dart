import 'package:flutter/material.dart';
import 'AdminHomePage.dart';

class MyLoginAsAdmin extends StatefulWidget {
  const MyLoginAsAdmin({Key? key}) : super(key: key);

  @override
  _MyLoginAsAdmin createState() => _MyLoginAsAdmin();
}

class _MyLoginAsAdmin extends State<MyLoginAsAdmin> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(''),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                'Login\nAs Admin',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            style: const TextStyle(color: Colors.black),
                            controller: _codeController,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Unique code",
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                                child: TextButton(
                                  onPressed: () {
                                    // Check if entered unique code is correct
                                    String enteredCode = _codeController.text.trim();
                                    String expectedCode = "12345678";
                                    if (enteredCode == expectedCode) {
                                      // Set loading state
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      // Simulate a loading delay
                                      Future.delayed(Duration(seconds: 2), () {
                                        // Navigate to the next page after loading delay
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => AdminHome()),
                                        );
                                      });
                                    } else {
                                      // Display an alert for incorrect code
                                      _showErrorDialog();
                                    }
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Loading indicator
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }


  // Function to show an alert dialog for incorrect code
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incorrect Code'),
          content: Text('Please enter the correct unique code.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
