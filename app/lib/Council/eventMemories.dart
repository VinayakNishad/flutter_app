import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Admin/imagesOfEvent.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseStorage _storage =
  FirebaseStorage.instanceFor(bucket: 'gs://applogin-4c8bd.appspot.com/files');

  String folderPath = 'gs://applogin-4c8bd.appspot.com/files'; // Replace with your actual folder path
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    try {
      ListResult result = await _storage.ref(folderPath).list();
      imageUrls = result.items.map((item) => item.fullPath).toList();
      setState(() {});
    } catch (e) {
      print('Error fetching image URLs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: const Text('Event memories'),
      ),
      body: ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Image ${index + 1}'),
              onTap: () {
                // You can navigate to a detail screen or implement
                // the desired behavior when tapping on an image.
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the ImagesOfEvent screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImagesOfEvent()),
          );
        },
        tooltip: 'Event Images',
        child: Icon(Icons.image),
      ),
    );
  }
}
