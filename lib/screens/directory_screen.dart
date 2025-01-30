import 'package:flutter/material.dart';

class DirectoryScreen extends StatelessWidget {
  final Map<String, List<String>> businesses = {
    'Restaurants': ['Mekelle Grill', 'Blue Nile Cafe'],
    'Shops': ['City Mart', 'Ethio Fashion'],
    'Hotels': ['Axum Hotel', 'Planet International'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Business Directory',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: ListView(
        children: businesses.entries.map((entry) {
          return ExpansionTile(
            title: Text(
              entry.key,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: entry.value.map((business) {
              return ListTile(
                title: Text(business),
                subtitle: Text('Category: ${entry.key}'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}