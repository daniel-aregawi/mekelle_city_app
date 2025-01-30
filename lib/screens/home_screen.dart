import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mekelle_city_app/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mekelle City Information Center'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _logout(context),
            child: Text(
              'Logout',
              style: TextStyle(
                  color: Colors.red), 
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_city, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Mekelle City Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
                context, Icons.message, 'Community Bulletin', '/bulletin'),
            _buildDrawerItem(context, Icons.business,
                'Local Business Directory', '/directory'),
            _buildDrawerItem(context, Icons.event, 'Event Calendar', '/events'),
            _buildDrawerItem(
                context, Icons.phone, 'Emergency Contacts', '/emergency'),
            _buildDrawerItem(context, Icons.miscellaneous_services,
                'City Services', '/services'),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2,
          children: [
            _buildFeatureCard(
                context, 'Community Bulletin', '/bulletin', Icons.message),
            _buildFeatureCard(context, 'Local Business Directory', '/directory',
                Icons.business),
            _buildFeatureCard(
                context, 'Event Calendar', '/events', Icons.event),
            _buildFeatureCard(
                context, 'Emergency Contacts', '/emergency', Icons.phone),
            _buildFeatureCard(context, 'City Services', '/services',
                Icons.miscellaneous_services),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, String title, String route, IconData icon) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
