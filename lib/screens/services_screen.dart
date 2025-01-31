import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'post_service_screen.dart'; // Import the post service screen

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List services = [];
  bool isLoading = true;
  String? userRole;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
    fetchServices();
  }

  // Fetch user role from SharedPreferences
  Future<void> fetchUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role');
    });
  }

  // Fetch services from the API
  Future<void> fetchServices() async {
    final response = await http.get(Uri.parse('http://localhost:3001/api/v1/cityService'));

    if (response.statusCode == 200) {
      setState(() {
        services = jsonDecode(response.body)['data'];
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load city services')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Delete a service
  Future<void> _deleteService(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('http://localhost:3001/api/v1/cityService/$id'),
      headers: {
        'Authorization': token != null ? 'Bearer $token' : '',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service deleted successfully.')),
      );
      await fetchServices(); // Refresh the list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete service.')),
      );
    }
  }

  // Create the collapsible widget for each service
  Widget _buildServiceCard(Map service) {
  return Card(
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: ExpansionTile(
      title: Text(
        service['name'],
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Icon(
        Icons.arrow_drop_down,
        size: 24,
        color: Colors.blue.shade800,
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to fill the width
            children: [
              // Center the image and text
              Center(
                child: Column(
                  children: [
                    if (service['picture'] != null)
                      Image.network(
                        'http://localhost:3001/${service['picture']}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    SizedBox(height: 8),
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      service['description'] ?? 'No description available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Align the delete button to the right
              if (userRole == 'ADMIN')
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteService(service['_id']);
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'City Services',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return _buildServiceCard(services[index]);
              },
            ),
      floatingActionButton: userRole == 'ADMIN'
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostServiceScreen()),
                );

                if (result == 'posted') {
                  fetchServices();
                }
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue.shade800,
            )
          : null,
    );
  }
}