import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker Demo',
      home: MyImagePicker(),
    );
  }
}

class MyImagePicker extends StatefulWidget {
  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File? _imageFile;
  String? _base64Image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
      _base64Image = base64Encode(_imageFile!.readAsBytesSync());
    });
  }

  Future<void> _uploadImage() async {
    if (_base64Image == null) return;

    final response = await http.post(
      Uri.parse('https://example.com/upload-image'),
      body: {'image': _base64Image},
    );

    if (response.statusCode == 200) {
      // Image uploaded successfully, do something here
    } else {
      // Error uploading image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: _imageFile == null
                  ? Text('No image selected.')
                  : Image.file(_imageFile!),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pick Image from Gallery'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Perform API hit with base64 encoded image
                if (_base64Image == null) return;
                http.post(
                  Uri.parse('https://example.com/api'),
                  body: {'image': _base64Image},
                );
              },
              child: Text('Hit API'),
            ),
            SizedBox(height: 16),
            // Text(_base64Image ?? ''),
          ],
        ),
      ),
    );
  }
}
