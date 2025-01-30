import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> events = [
    {'title': 'City Hall Meeting', 'date': DateTime(2023, 10, 15)},
    {'title': 'Community Cleanup Day', 'date': DateTime(2023, 10, 20)},
    {'title': 'New Park Opening', 'date': DateTime(2023, 10, 25)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Calendar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                event['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                DateFormat('MMMM d, y').format(event['date']),
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade600,
              ),
            ),
          );
        },
      ),
    );
  }
}