import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      // Ensure passwords match
      if (_passwordController.text != _passwordConfirmController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match.')),
        );
        return;
      }

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        'email': _emailController.text,
        'password': _passwordController.text,
        'passwordConfirm': _passwordConfirmController.text,
      };

      try {
        // Send POST request to the backend
        final response = await http.post(
          Uri.parse('http://localhost:3001/api/v1/users/signup'), // Your backend URL
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );

        // Handle the response
        if (response.statusCode == 201) {
          // Success: User created
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signup successful!')),
          );
          Navigator.pop(context); // Go back to the previous screen
        } else {
          // Error: Handle specific error messages
          final responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Signup failed. Please try again.')),
          );
        }
      } catch (error) {
        // Handle network or server errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please check your connection.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              // Password Confirm Field
              TextFormField(
                controller: _passwordConfirmController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              // Spacing
              SizedBox(height: 20),

              // Signup Button
              ElevatedButton(
                onPressed: _signup,
                child: Text('Signup'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}