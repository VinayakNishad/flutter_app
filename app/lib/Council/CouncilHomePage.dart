import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/Student/LeaderboardScreenStudent.dart';
import '../Admin/imagesOfEvent.dart';
import '../CommonInterface/interface.dart';
import '../Student/StudentMain.dart';
import 'eventMemories.dart';
import 'AddEvent.dart';
import 'MainPage.dart';
import '../Admin/ResultAdmin/ResultScreen.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  int currentTab = 0;
  final List<Widget> screens = [
    MainPage(),
    HomeScreen(),
    ResultScreen(),
    LeaderboardScreenStudent(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  static const IconData event = IconData(0xe23e, fontFamily: 'MaterialIcons');
  static const IconData menu_book = IconData(0xe3dd, fontFamily: 'MaterialIcons');
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
        elevation: 8,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[900], // Set drawer background color
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Text(
                  'Username',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              buildDrawerItem(Icons.celebration, 'Get Certificate', () {
                Navigator.pop(context);
              }),
              buildDrawerItem(Icons.history, 'Recent Events', () {
                // Handle Recent Events tap
              }),
              Divider(
                color: Colors.white, // Set the color of the divider
                thickness: 1, // Set the thickness of the divider
                height: 10, // Set the height of the divider
              ),
              buildDrawerItem(Icons.logout, 'Log out', () async {
                Navigator.pop(context);

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
              }),
            ],
          ),
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
            elevation: 0,
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
      floatingActionButton: currentTab == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Create()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildDrawerItem(IconData icon, String text, Function() onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      onTap: onTap,
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
              color: currentTab == tabIndex ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
