import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/homepage/menu.dart';
import 'package:nobarpedia_mobile/join/models/NobarSpot.dart';
import 'package:nobarpedia_mobile/join/screens/menu.dart';
import 'package:nobarpedia_mobile/join/widgets/joinlist_form.dart';
import 'dart:convert';
import 'package:nobarpedia_mobile/config.dart';

// dummy data
final String jsonString = useProductionUrl
    ? """                                                                                           
{
  "id": "cbab4863-b856-40ed-b734-21b2eed8dd27",
  "name": "Pizza e Birra Sports Bar Cilandak Town Square",
  "city": "Jakarta",
  "time": "14:43",
  "host_id": "2",
  "host_username": "pbp",
  "joined_count": 1
}                                                                                                             
"""
    : """
// insert, prev data was wrong endpoint
""";

final NobarSpot nobarSpot = NobarSpot.fromJson(json.decode(jsonString));

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Column(
              children: [
                Text(
                  'Nobarpedia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Join a nobar spot!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Colors.grey),
            title: const Text('Home', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text(
              'Joined Spots',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => JoinPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.grey),
            title: const Text('My Spots', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JoinPage(mine: true),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box_outlined, color: Colors.grey),
            title: const Text(
              'Create Nobar Spot',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateJoinPage(place: nobarSpot),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.login, color: Colors.grey),
            // TODO: Change to logout button if already logged in
            title: const Text('Login', style: TextStyle(color: Colors.grey)),
            onTap: () {
              // Redirect to Login Page
              Navigator.pushReplacement(
                context,
                // TODO: change route
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
