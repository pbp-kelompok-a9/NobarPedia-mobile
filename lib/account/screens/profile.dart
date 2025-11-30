import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../models/user_profile.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<UserProfile> fetchProfile(CookieRequest request) async {
    final url = "$baseUrl/account/api/view_profile/${widget.userId}";
    final response = await request.get(url);

    return UserProfile.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF333333),
      ),

      body: FutureBuilder(
        future: fetchProfile(request),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final user = snapshot.data as UserProfile;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 70),
            child: Center(
              child: Container(
                width: 600,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  children: [
                    // PROFILE PICTURE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        user.profilePictureUrl.isNotEmpty
                            ? user.profilePictureUrl
                            : "",
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      user.fullname,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _field("Username", user.username),
                    _field("Email", user.email),
                    _field("Fullname", user.fullname),
                    _bioField("Bio", user.bio),

                    const SizedBox(height: 20),

                    if (user.showUpdateButton)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.white)),
      const SizedBox(height: 8),

      TextField(
        enabled: false,
        controller: TextEditingController(text: value),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF222222),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white24),
          ),
        ),
      ),
      const SizedBox(height: 20),
    ],
  );

  Widget _bioField(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.white)),
      const SizedBox(height: 8),

      TextField(
        enabled: false,
        controller: TextEditingController(text: value),
        maxLines: 3,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF222222),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white24),
          ),
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}
