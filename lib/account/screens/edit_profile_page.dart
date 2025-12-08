import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/account/screens/change_password.dart';
import 'package:nobarpedia_mobile/account/screens/login.dart';
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

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User harus klik button biar ngeclose
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF333333),
          title: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete your account?',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 10),
                Text(
                  'This action cannot be undone.',
                  style: TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Cancel Button
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            // Delete Button
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                _performDeleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDeleteAccount() async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.post(
        "$baseUrl/account/api/delete_profile/${widget.id}/",
        {},
      );

      if (!context.mounted) return;

      if (response['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deleted successfully.")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Failed to delete account"),
            backgroundColor: const Color(0xFFE53E3E),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error on delete_profile: $e"),
            backgroundColor: const Color(0xFFE53E3E),
          ),
        );
      }
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

  InputDecoration webInputStyle(String? labelInput, String? hintInput) {
    return InputDecoration(
      labelText: labelInput,
      hintText: hintInput,
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
      floatingLabelStyle: const TextStyle(
        color: Color(0xFF2CAC5C),
        fontSize: 18,
      ),
      labelStyle: const TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
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
                // const Text("Username", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 6),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: webInputStyle("Username", "Enter your username"),
                ),
                const SizedBox(height: 16),

                // Email
                const SizedBox(height: 6),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: webInputStyle("Email", "Enter your email"),
                ),
                const SizedBox(height: 16),

                // Fullname
                // const Text("Full Name", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 6),
                TextField(
                  controller: fullnameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: webInputStyle(
                    "Full Name",
                    "Enter your full name",
                  ),
                ),
                const SizedBox(height: 16),

                // Bio
                // const Text("Bio", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 6),
                TextField(
                  controller: bioController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: webInputStyle("Bio", "Enter your bio"),
                ),

                const SizedBox(height: 24),

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

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordPage(
                              profile: widget.profile,
                              id: widget.id,
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD69E2E)),
                          foregroundColor: const Color(0xFF333333),
                          backgroundColor: const Color(0xFFF6E05E),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Change Password"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showDeleteConfirmation(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE53E3E)),
                          foregroundColor: const Color(0xFF333333),
                          backgroundColor: const Color(0xFFF56565),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Delete Account"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
