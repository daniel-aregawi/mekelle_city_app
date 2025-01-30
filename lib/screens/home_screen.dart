import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mekelle City Information Center'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Feature Buttons
            _buildFeatureButton(context, 'Community Bulletin', '/bulletin'),
            _buildFeatureButton(context, 'Local Business Directory', '/directory'),
            _buildFeatureButton(context, 'Event Calendar', '/events'),
            _buildFeatureButton(context, 'Emergency Contacts', '/emergency'),
            _buildFeatureButton(context, 'City Services', '/services'),

            // Spacing
            SizedBox(height: 20),

            // Signup Button
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: Text('Signup'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),

            // Spacing
            SizedBox(height: 10),

            // Login Button
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build feature buttons
  Widget _buildFeatureButton(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
      ),
    );
  }
}