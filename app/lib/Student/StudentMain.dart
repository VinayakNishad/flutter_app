import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Admin/ResultAdmin/ResultScreen.dart';
import '../CommonInterface/interface.dart';
import '../Council/MainPage.dart';
import '../Council/eventMemories.dart';
import 'LeaderboardScreenStudent.dart';

class StudentMain extends StatefulWidget {
  final String email;

  const StudentMain({Key? key, required this.email}) : super(key: key);

  @override
  _StudentMain createState() => _StudentMain();
}

class _StudentMain extends State<StudentMain> {
  String fullName = "Username"; // Default value
  int currentTab = 0;
  final List<Widget> screens = [
    MainPage(),
    HomeScreen(),
    ResultScreen(),
    LeaderboardScreenStudent(),
  ];
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
  final PageStorageBucket bucket = PageStorageBucket();
  static const IconData event =
  IconData(0xe23e, fontFamily: 'MaterialIcons');
  static const IconData menu_book =
  IconData(0xe3dd, fontFamily: 'MaterialIcons');
  Widget currentScreen = MainPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Campus Connect',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 8, // Remove elevation
        actions: [
          // Notification Icon
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
              // You can show a notification screen or any other action
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.email,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Get Certificate',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Recent Events',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Handle Option Y tap
              },
            ),
            ListTile(
              title: Text(
                'Log out',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () async {
                // Show loading page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingPage()),
                );

                // Log out the user
                await logout();

                // Navigate to DropdownMenuApp
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DropdownMenuApp()),
                );
              },
            ),
          ],
        ),
      ),
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          return BottomAppBar(
            color: Colors.black,
            elevation: 0, // Add elevation
            child: Container(
              height: constraints.maxHeight * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  buildNavBarItem(Icons.home, 'Home', 0),
                  buildNavBarItem(event, 'Events', 1),
                  buildNavBarItem(menu_book, 'Results', 2),
                  buildNavBarItem(Icons.leaderboard, 'Leaderboard', 3),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, String text, int tabIndex) {
    return MaterialButton(
      minWidth: 10,
      onPressed: () {
        setState(() {
          currentScreen = screens[tabIndex];
          currentTab = tabIndex;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: currentTab == tabIndex ? Colors.white : Colors.grey,
          ),
          const SizedBox(height: 1),
          Text(
            text,
            style: TextStyle(
              color:
              currentTab == tabIndex ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(backgroundColor: Colors.transparent),
      ),
    );
  }
}
