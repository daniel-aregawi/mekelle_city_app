import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;
import 'post_bulletin_screen.dart';

class BulletinScreen extends StatefulWidget {
  @override
  _BulletinScreenState createState() => _BulletinScreenState();
}

class _BulletinScreenState extends State<BulletinScreen> {
  List bulletins = [];
  String? userRole;

  @override

 void initState() {
    super.initState();
    fetchUserRole();
    fetchBulletins();
  }

  Future<void> fetchUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role');
    });
  }

  Future<void> fetchBulletins() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://localhost:3001/api/v1/communityBullet/'),
      headers: {
        'Authorization': token != null ? 'Bearer $token' : '',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        bulletins = jsonDecode(response.body)['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch bulletins.')),
      );
    }
  }

String formatTime(String createdAt) {
  DateTime postDate = DateTime.parse(createdAt).toLocal();
  String timeAgo = timeago.format(postDate, locale: 'en'); // 
  String formattedDate = "${postDate.day}/${postDate.month}/${postDate.year}"; // "dd/mm/yyyy"
  return '$timeAgo - $formattedDate'; 
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Community Bulletin',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,  // Matching color
    ),
    body: bulletins.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: bulletins.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundImage: bulletins[index]['picture'] != null
                          ? NetworkImage(bulletins[index]['picture'])
                          : AssetImage('assets/default_image.png')
                              as ImageProvider,
                      radius: 25,
                    ),
                    title: Text(
                      bulletins[index]['name'],
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,  // Matching color
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bulletins[index]['description'],
                          style: TextStyle(
                            fontSize: 14, 
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          formatTime(bulletins[index]['createdAt']),
                          style: TextStyle(
                            fontSize: 12, 
                            color: Colors.grey[500],
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
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostBulletinScreen()),
              );

              if (result == 'posted') {
                fetchBulletins();
              }
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blueAccent, 
          )
        : null,
  );
}

}
