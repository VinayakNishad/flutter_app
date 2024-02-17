import 'package:app/Admin/LeaderBoardAdmin/LeaderBoardScreen.dart';
import 'package:app/Admin/imagesOfEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Council/AddEvent.dart';
import 'package:app/Admin/ShowContentInListFormat.dart';
import 'package:app/Admin/AdminEventScreen.dart';
import 'AddCouncilMember.dart';
import 'ResultAdmin/EventResult.dart';
import 'LeaderBoardAdmin/UpdateLeaderBoard.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHome createState() => _AdminHome();
}

class _AdminHome extends State<AdminHome> with SingleTickerProviderStateMixin {
  // Add this variable
  String adminName = "John Doe";
  late TabController _tabController;
  bool showFloatingActionButton = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    // Check the current tab index and decide whether to show the floating button
    if (_tabController.indexIsChanging) {
      setState(() {
        showFloatingActionButton = _tabController.index == 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Member'),
              Tab(text: 'Event'),
              Tab(text: 'Certificate'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(adminName),
                accountEmail: null, // You can add the admin's email here if needed
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    adminName.isNotEmpty ? adminName[0].toUpperCase() : '?',
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
                otherAccountsPictures: [
                  GestureDetector(
                    onTap: () {
                      _editAdminName(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
              ListTile(
                title: Text('Add Result'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventResult()),
                  );
                },
              ),
              ListTile(
                title: Text('Leaderboard'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                  );
                },
              ),
              ListTile(
                title: Text('Event'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminEventScreen()),
                  );
                },
              ),
              ListTile(
                title: Text('Event images'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImagesOfEvent()),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: showFloatingActionButton
            ? FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMember()),
            );
          },
          child: Icon(Icons.add),
        )
            : null,
        body: TabBarView(
          children: [
            // Content for Tab 1
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('CouncilMember')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var leaderboardData = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: leaderboardData.length,
                  itemBuilder: (context, index) {
                    var data = leaderboardData[index].data() as Map<String, dynamic>;
                    String name = data['Name'];
                    String position = data['Position'];

                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blue, width: 2),
                      ),
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text('Position: $position'),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(position.substring(0, 2).toUpperCase()),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteDialog(context, name, index);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Content for Tab 2
            Center(
              child: ShowContentInListFormat(), // Your ShowContent widget
            ),

            // Content for Tab 3
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Button 1 action
                },
                child: const Text(
                  'Generate certificate',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editAdminName(BuildContext context) {
    TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Admin Name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Enter new name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  adminName = _nameController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
  void _showDeleteDialog(BuildContext context, String name, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete $name?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteData(index);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  void _deleteData(int index) {
    // Delete data from the database using index
    FirebaseFirestore.instance.collection('CouncilMember').doc(index.toString()).delete();
  }
}
Future<List<Events>> fetchEvents() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Event').get();

      List<Events> eventsList = querySnapshot.docs.map((doc) {
        return Events.fromJson(doc.data(), doc.id);
      }).toList();

      return eventsList;
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }
// Function to remove event from the list
void removeEvent(Events event, List<Events> eventsList) {
  eventsList.remove(event);
  // You might need to call setState to update the UI if using StatefulWidget
}
  // Function to update status to true
  void approveEvent(Events event) async {
    try {
      await FirebaseFirestore.instance
          .collection('Event')
          .doc(event.id)
          .update({'status': true});
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  // Function to remove event from the database
  void rejectEvent(Events event) async {
    try {
      await FirebaseFirestore.instance.collection('Event').doc(event.id).delete();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

