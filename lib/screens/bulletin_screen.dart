import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post_bulletin_screen.dart';

class BulletinScreen extends StatefulWidget {
  @override
  _BulletinScreenState createState() => _BulletinScreenState();
}

class _BulletinScreenState extends State<BulletinScreen> {
  List bulletins = [];

  @override
  void initState() {
    super.initState();
    fetchBulletins();
  }

  Future<void> fetchBulletins() async {
    final response = await http.get(
      Uri.parse('http://localhost:3001/api/v1/communityBullet/'),
      headers: {'Authorization': 'Bearer YOUR_TOKEN_HERE'},
    );

    if (response.statusCode == 200) {
      setState(() {
        bulletins = jsonDecode(response.body)['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Bulletin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: bulletins.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: bulletins.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: CircleAvatar(
                        backgroundImage: bulletins[index]['picture'] != null
                            ? NetworkImage(bulletins[index]['picture'])
                            : AssetImage('assets/default_image.png') as ImageProvider,
                        radius: 25,
                      ),
                      title: Text(
                        bulletins[index]['name'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        bulletins[index]['description'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostBulletinScreen()),
          );

          if (result == 'posted') {
            fetchBulletins(); 
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor, 
      ),
    );
  }
}
