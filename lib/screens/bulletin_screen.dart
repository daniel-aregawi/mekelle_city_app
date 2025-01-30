import 'package:flutter/material.dart';

class BulletinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Bulletin'),
      ),
      body: ListView(
        children: [
          ListTile(title: Text('Announcement 1')),
          ListTile(title: Text('Announcement 2')),
          // Add more announcements dynamically
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to post a new announcement
        },
        child: Icon(Icons.add),
      ),
    );
  }
}