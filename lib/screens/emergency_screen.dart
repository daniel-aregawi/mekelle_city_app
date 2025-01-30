import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  final Map<String, String> contacts = {
    'Police': '911',
    'Fire Department': '912',
    'Hospital': '913',
    'Ambulance': '914',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency Contacts',
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
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final key = contacts.keys.elementAt(index);
          final value = contacts[key];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                key,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                value!,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              trailing: Icon(
                Icons.call,
                color: Colors.red.shade600,
              ),
              onTap: () => launch('tel:$value'),
            ),
          );
        },
      ),
    );
  }
}