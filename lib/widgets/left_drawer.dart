import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/account/screens/admin_account_page.dart';
import 'package:nobarpedia_mobile/account/screens/login.dart';
import 'package:nobarpedia_mobile/account/screens/profile.dart';
import 'package:nobarpedia_mobile/account/screens/register.dart';
import 'package:nobarpedia_mobile/homepage/menu.dart';
import 'package:nobarpedia_mobile/join/models/nobar_spot.dart';
import 'package:nobarpedia_mobile/join/screens/menu.dart';
import 'package:nobarpedia_mobile/join/widgets/joinlist_form.dart';
import 'dart:convert';
import 'package:nobarpedia_mobile/config.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

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
{
  "id": "cdc29475-60cc-4fa5-9f30-440129072327",
  "name": "boing",
  "city": "depok",
  "time": "17:18",
  "host_id": "1",
  "host_username": "pbp",
  "joined_count": 0
}
""";

final NobarSpot nobarSpot = NobarSpot.fromJson(json.decode(jsonString));

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  Future<List<dynamic>?> fetchUserIdAndRole(CookieRequest request) async {
    try {
      final data = await request.get("$baseUrl/account/api/current_user_id/");
      return [data["id"], data["is_admin"]];
    } catch (_) {
      return null;
    }
  }

  Widget homeOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.home_outlined, color: Colors.grey),
      title: const Text('Home', style: TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      },
    );
  }

  Widget joinedSpotsOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.list_alt),
      title: const Text('Joined Spots', style: TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => JoinPage()),
        );
      },
    );
  }

  Widget mySpotsOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person_outline, color: Colors.grey),
      title: const Text('My Spots', style: TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JoinPage(mine: true)),
        );
      },
    );
  }

  Widget joinFormOption(BuildContext context) {
    // TODO: remove when review module has been integrated
    return ListTile(
      leading: const Icon(Icons.add_box_outlined, color: Colors.grey),
      title: const Text(
        'Join form (TEMP)',
        style: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateJoinPage(
              id: nobarSpot.id,
              name: nobarSpot.name,
              city: nobarSpot.city,
            ),
          ),
        );
      },
    );
  }

  Widget loginOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.login, color: Colors.grey),
      title: const Text('Login', style: TextStyle(color: Colors.grey)),
      onTap: () {
        // Redirect to Login Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
    );
  }

  Widget registerOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.create_outlined, color: Colors.grey),
      title: const Text('Register', style: TextStyle(color: Colors.grey)),
      onTap: () {
        // Redirect to Login Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      },
    );
  }

  Widget profileOption(BuildContext context, request, userId) {
    return ListTile(
      leading: const Icon(Icons.account_circle_rounded, color: Colors.grey),
      title: const Text('Profile', style: TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(userId: userId)),
        );
      },
    );
  }

  Widget accountAdminPageOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.manage_accounts, color: Colors.grey),
      title: const Text('Account', style: TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.pushReplacement(
          context,
          // TODO: ganti dengan page admin masing2 module yeah
          MaterialPageRoute(builder: (context) => AdminAccountPage()),
        );
      },
    );
  }

  Widget homepageAdminPageOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.home_sharp, color: Colors.grey),
      title: const Text('Homepage', style: TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.pushReplacement(
          context,
          // TODO: ganti dengan page admin masing2 module yeah
          MaterialPageRoute(builder: (context) => AdminAccountPage()),
        );
      },
    );
  }

  Widget joinAdminPageOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.connect_without_contact_rounded, color: Colors.grey),
      title: const Text('Join', style: TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.pushReplacement(
          context,
          // TODO: ganti dengan page admin masing2 module yeah
          MaterialPageRoute(builder: (context) => AdminAccountPage()),
        );
      },
    );
  }

  Widget matchAdminPageOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.sports_basketball, color: Colors.grey),
      title: const Text('Match', style: TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.pushReplacement(
          context,
          // TODO: ganti dengan page admin masing2 module yeah
          MaterialPageRoute(builder: (context) => AdminAccountPage()),
        );
      },
    );
  }  
  
  Widget reviewAdminPageOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.rate_review_rounded, color: Colors.grey),
      title: const Text('Review', style: TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.pushReplacement(
          context,
          // TODO: ganti dengan page admin masing2 module yeah
          MaterialPageRoute(builder: (context) => AdminAccountPage()),
        );
      },
    );
  }

  Widget logoutOption(BuildContext context, request) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.grey),
      title: const Text('Logout', style: TextStyle(color: Colors.grey)),
      onTap: () async {
        final response = await request.logout("$baseUrl/account/api/logout/");
        String message = response["message"];
        if (context.mounted) {
          if (response['status']) {
            String uname = response["username"];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$message See you again, $uname.")),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        }
      },
    );
  }

  Widget loggedInDrawerBuilder(BuildContext context, request) {
    return FutureBuilder<List<dynamic>?>(
      future: fetchUserIdAndRole(request),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ListTile(
            title: Text("Loading...", style: TextStyle(color: Colors.grey)),
          );
        }

        final userId = snapshot.data?[0] as int;
        final isAdmin = snapshot.data?[1] as bool;

        if (isAdmin) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // tambahin option admin page dari masing2 module...
              accountAdminPageOption(context),
              homepageAdminPageOption(context),
              joinAdminPageOption(context),
              matchAdminPageOption(context),
              reviewAdminPageOption(context),
            const SizedBox(height: 7),
              const Divider(color: Colors.grey),
            const SizedBox(height: 7),
              profileOption(context, request, userId),
              logoutOption(context, request),
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            homeOption(context),
            joinedSpotsOption(context),
            mySpotsOption(context),
            joinFormOption(context),
            const SizedBox(height: 1),
            const Divider(color: Colors.grey),
            const SizedBox(height: 1),
            profileOption(context, request, userId),
            logoutOption(context, request),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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

          if (request.loggedIn) ...[
            // Kalo user udah login
            loggedInDrawerBuilder(context, request),
          ] else ...[
            // Kalo user BELUM login
            homeOption(context),
            joinedSpotsOption(context),
            mySpotsOption(context),
            joinFormOption(context),
            loginOption(context),
            registerOption(context),
          ],
        ],
      ),
    );
  }
}
