import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;
import 'post_directory_screen.dart';

class DirectoryScreen extends StatefulWidget {
  @override
  _DirectoryScreenState createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  List businesses = [];
  String? userRole;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
    fetchBusinesses();
  }

  Future<void> fetchUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role');
    });
  }

  Future<void> fetchBusinesses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://localhost:3001/api/v1/localBusiness/'),
      headers: {
        'Authorization': token != null ? 'Bearer $token' : '',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        businesses = jsonDecode(response.body)['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch businesses.')),
      );
    }
  }

  String formatTime(String createdAt) {
    DateTime postDate = DateTime.parse(createdAt).toLocal();
    String timeAgo = timeago.format(postDate, locale: 'en');
    String formattedDate = "${postDate.day}/${postDate.month}/${postDate.year}";
    return '$timeAgo - $formattedDate';
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Business Directory',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
    ),
    body: businesses.isEmpty
        ? Center(
            child: businesses.isEmpty && businesses.length == 0
                ? Text(
                    'No business directories yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  )
                : CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image (Square and Fixed Size)
                        if (businesses[index]['picture'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              'http://localhost:3001/${businesses[index]['picture']}',
                              width: 180, // Increased width
                              height: 120, // Increased height
                              fit: BoxFit.cover,
                            ),
                          ),
                        SizedBox(width: 12),

                        // Text Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                businesses[index]['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 5),

                              // Description
                              Text(
                                businesses[index]['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),

                              // Timestamp
                              Text(
                                formatTime(businesses[index]['createdAt']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
    floatingActionButton: userRole == 'ADMIN'
        ? FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDirectoryScreen()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
          )
        : null,
  );
}
}
