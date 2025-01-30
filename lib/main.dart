import 'package:flutter/material.dart';
import 'package:mekelle_city_app/screens/home_screen.dart';
import 'package:mekelle_city_app/screens/login_screen.dart';
import 'package:mekelle_city_app/screens/signup_screen.dart';
import 'package:mekelle_city_app/screens/bulletin_screen.dart'; // Import screens
import 'package:mekelle_city_app/screens/directory_screen.dart';
import 'package:mekelle_city_app/screens/events_screen.dart';
import 'package:mekelle_city_app/screens/emergency_screen.dart';
import 'package:mekelle_city_app/screens/services_screen.dart';
import 'package:mekelle_city_app/screens/logout_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mekelle City App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/logout': (context) => LogoutScreen(),
        '/bulletin': (context) => BulletinScreen(), // Add route for BulletinScreen
        '/directory': (context) => DirectoryScreen(), // Add route for DirectoryScreen
        '/events': (context) => EventsScreen(), // Add route for EventsScreen
        '/emergency': (context) => EmergencyScreen(), // Add route for EmergencyScreen
        '/services': (context) => ServicesScreen(), // Add route for ServicesScreen
      },
    );
  }
}
