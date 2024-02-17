import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagesOfEvent extends StatefulWidget {
  @override
  _ImagesOfEventState createState() => _ImagesOfEventState();
}

class _ImagesOfEventState extends State<ImagesOfEvent> {
  List<File> _imageList = [];

  Future<void> _getImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageList.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageList.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _uploadImagesToFirebase() async {
    final storage = FirebaseStorage.instance;

    for (File image in _imageList) {
      try {
        final Reference storageReference =
        storage.ref().child('/files/${DateTime.now().toString()}');
        final UploadTask uploadTask = storageReference.putFile(image);

        await uploadTask.whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image uploaded successfully.'),
              duration: Duration(seconds: 2),
            ),
          );
        });

        String imageUrl = await storageReference.getDownloadURL();
        print('Image uploaded successfully. URL: $imageUrl');

        // You can save the imageUrl to a database or display it in your UI as needed.
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            duration: Duration(seconds: 2),
          ),
        );
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Images'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Display selected images in a grid of two
          if (_imageList.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _imageList.length,
              itemBuilder: (context, index) {
                return Image.file(_imageList[index]);
              },
            )
          else
            Icon(Icons.image, size: 100, color: Colors.grey),  // Placeholder image icon

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Camera icon to open the device camera
              IconButton(
                icon: Icon(Icons.camera, color: Colors.blue),
                onPressed: () => _getImageFromCamera(),
              ),
              // Gallery icon to open the device gallery
              IconButton(
                icon: Icon(Icons.image, color: Colors.green),
                onPressed: () => _getImageFromGallery(),
              ),
            ],
          ),

          SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: _uploadImagesToFirebase,
            icon: Icon(Icons.cloud_upload),
            label: Text('Upload to Firebase'),
          ),
        ],
      ),
    );
  }
}
