import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/account/screens/profile.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'package:nobarpedia_mobile/account/models/user_profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile profile;
  final int id;

  const EditProfilePage({super.key, required this.profile, required this.id});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController fullnameController;
  late TextEditingController bioController;

  bool isSubmitting = false;
  Map<String, dynamic>? errors;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.profile.username);
    emailController = TextEditingController(text: widget.profile.email);
    fullnameController = TextEditingController(text: widget.profile.fullname);
    bioController = TextEditingController(text: widget.profile.bio);
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    fullnameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    final request = context.read<CookieRequest>();

    setState(() {
      isSubmitting = true;
      errors = null;
    });

    final response = await request
        .post("$baseUrl/account/api/edit_profile/${widget.id}/", {
          "username": usernameController.text,
          "email": emailController.text,
          "fullname": fullnameController.text,
          "bio": bioController.text,
        });

    if (response["status"] == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userId: widget.id),
          ),
        );
      }
    } else {
      setState(() {
        errors = response["message"];
        isSubmitting = false;
      });
    }
  }

  Widget errorBox() {
    if (errors == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: errors!.entries.map((entry) {
          if (entry.key == "__all__") {
            return Text(
              entry.value.join("\n"),
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var e in entry.value)
                Text(
                  "${entry.key.toUpperCase()}: $e",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  InputDecoration webInputStyle() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF333333),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF666666)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF666666)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2CAC5C), width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.white70),
    );
  }

  Widget saveButton() {
    return ElevatedButton(
      onPressed: isSubmitting ? null : submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2CAC5C),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        "Update Profile",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget cancelButton() {
    return OutlinedButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.id)),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF666666)),
        backgroundColor: const Color(0xFF333333),
        foregroundColor: Colors.white70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text("Cancel"),
    );
  }

  Widget secondaryButton(String text, Color border, Color color) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: border),
        backgroundColor: const Color(0xFF333333),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        elevation: 0,
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 40, bottom: 20),
        child: Center(
          child: Container(
            width: 600,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: NetworkImage(
                        "$baseUrl/${widget.profile.profilePictureUrl}",
                      ),
                      onBackgroundImageError: (_, __) {},
                      backgroundColor: const Color(0xFF333333),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                errorBox(),

                const SizedBox(height: 8),

                // Username
                const Text("Username", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 6),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: webInputStyle(),
                ),
                const SizedBox(height: 16),

                // Email
                const Text("Email", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 6),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: webInputStyle(),
                ),
                const SizedBox(height: 16),

                // Fullname
                const Text("Full Name", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 6),
                TextField(
                  controller: fullnameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: webInputStyle(),
                ),
                const SizedBox(height: 16),

                // Bio
                const Text("Bio", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 6),
                TextField(
                  controller: bioController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: webInputStyle(),
                ),

                const SizedBox(height: 24),
                const Divider(color: Colors.grey),

                Row(
                  children: [
                    Expanded(child: cancelButton()),
                    const SizedBox(width: 12),
                    Expanded(child: saveButton()),
                  ],
                ),

                const SizedBox(height: 24),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16),

                secondaryButton(
                  "Change Password",
                  const Color(0xFFD69E2E),
                  const Color(0xFFF6E05E),
                ),
                const SizedBox(height: 12),
                secondaryButton(
                  "Delete Account",
                  const Color(0xFFE53E3E),
                  const Color(0xFFF56565),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
