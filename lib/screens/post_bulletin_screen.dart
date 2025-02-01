import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; 


class PostBulletinScreen extends StatefulWidget {
  @override
  _PostBulletinScreenState createState() => _PostBulletinScreenState();
}

class _PostBulletinScreenState extends State<PostBulletinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;
  Uint8List? _imageBytes;
  String? _fileName;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, 
      withData: true, 
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        if (kIsWeb) {
          _imageBytes = result.files.single.bytes; 
        } else {
          _imageFile = File(result.files.single.path!); 
        }
      });
    }
  }

  Future<void> _postBulletin() async {
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
      Uri.parse('http://localhost:3001/api/v1/communityBullet/'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = _nameController.text;
    request.fields['description'] = _descriptionController.text;

    if (_imageFile != null) {
      var fileStream = http.ByteStream(Stream.castFrom(_imageFile!.openRead()));
      var fileLength = await _imageFile!.length();

      var multipartFile = http.MultipartFile(
        'picture',
        fileStream,
        fileLength,
        filename: _fileName,
        contentType: MediaType('image', 'jpeg'), 
      );

      request.files.add(multipartFile);
    } else if (_imageBytes != null) {
      // For web
      var multipartFile = http.MultipartFile.fromBytes(
        'picture',
        _imageBytes!,
        filename: _fileName,
        contentType: MediaType('image', 'jpeg'), 
      );

      request.files.add(multipartFile);
    }

    print("Request Fields: ${request.fields}");
    print("Request Files: ${request.files}");

    var response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bulletin posted successfully!')),
      );
      Navigator.pop(context, 'posted');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post bulletin.')),
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
      appBar: AppBar(title: Text('Post a Bulletin')),
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
                      labelText: 'Bulletin Name',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter bulletin name' : null,
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
                      onPressed: _postBulletin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Post Bulletin',
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
