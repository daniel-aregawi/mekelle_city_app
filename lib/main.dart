import 'package:flutter/material.dart';
import 'package:mekelle_city_app/screens/home_screen.dart';
import 'package:mekelle_city_app/screens/bulletin_screen.dart';
import 'package:mekelle_city_app/screens/directory_screen.dart';
import 'package:mekelle_city_app/screens/events_screen.dart';
import 'package:mekelle_city_app/screens/emergency_screen.dart';
import 'package:mekelle_city_app/screens/services_screen.dart';
import 'package:mekelle_city_app/screens/signup_screen.dart';
import 'package:mekelle_city_app/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mekelle City App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
routes: {
  '/bulletin': (context) => BulletinScreen(),
  '/directory': (context) => DirectoryScreen(),
  '/events': (context) => EventsScreen(),
  '/emergency': (context) => EmergencyScreen(),
  '/services': (context) => ServicesScreen(),
  '/signup': (context) => SignupScreen(),
  '/login': (context) => LoginScreen(), 
},
    );
  }
}