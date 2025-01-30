import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // For web file handling

class PostDirectoryScreen extends StatefulWidget {
  @override
  _PostDirectoryScreenState createState() => _PostDirectoryScreenState();
}

class _PostDirectoryScreenState extends State<PostDirectoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;
  Uint8List? _imageBytes;
  String? _fileName;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Only allow image selection
      withData: true, // Needed for web
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        if (kIsWeb) {
          _imageBytes = result.files.single.bytes; // Web support
        } else {
          _imageFile = File(result.files.single.path!); // Mobile support
        }
      });
    }
  }

  Future<void> _postBusinessDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to log in first.')),
      );
      return;
    }

    if (_formKey.currentState!.validate() && (_imageFile != null || _imageBytes != null)) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:3001/api/v1/localBusiness/'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = _nameController.text;
      request.fields['category'] = _categoryController.text;
      request.fields['description'] = _descriptionController.text;

      if (_imageFile != null) {
        // For mobile
        var fileStream = http.ByteStream(Stream.castFrom(_imageFile!.openRead()));
        var fileLength = await _imageFile!.length();

        var multipartFile = http.MultipartFile(
          'picture',
          fileStream,
          fileLength,
          filename: _fileName,
          contentType: MediaType('image', 'jpeg'), // Manually set MIME type
        );

        request.files.add(multipartFile);
      } else if (_imageBytes != null) {
        // For web
        var multipartFile = http.MultipartFile.fromBytes(
          'picture',
          _imageBytes!,
          filename: _fileName,
          contentType: MediaType('image', 'jpeg'), // Manually set MIME type
        );

        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Business posted successfully!')),
        );
        Navigator.pop(context, 'posted');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post business.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post a Business')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Business Name',
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter business name' : null,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter category' : null,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                  ),
                  SizedBox(height: 15),
                  _imageBytes != null || _imageFile != null
                      ? Image.memory(_imageBytes ?? _imageFile!.readAsBytesSync(), height: 100)
                      : Text('No image selected'),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text('Select Image'),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _postBusinessDirectory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Post Business',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
