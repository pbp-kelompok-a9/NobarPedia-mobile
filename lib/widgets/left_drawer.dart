import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/homepage/menu.dart';
import 'package:nobarpedia_mobile/join/screens/menu.dart';
// import 'package:nobarpedia_mobile/screens/productlist_form.dart';
// import 'package:nobarpedia_mobile/screens/product_entry_list.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(30, 30, 30, 1),
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
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home', style: TextStyle(color: Colors.grey)),
            // Redirect to Home page
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Join', style: TextStyle(color: Colors.grey)),
            // Redirect to Join page
            onTap: () {
              Navigator.pushReplacement(
                context,
                // TODO: change route
                MaterialPageRoute(builder: (context) => JoinPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            // TODO: Change to logout button if already logged in
            title: const Text('Login',
            style: TextStyle(color: Colors.grey)),
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
