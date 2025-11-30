import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/account/models/user_profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'package:nobarpedia_mobile/account/screens/edit_profile_page.dart';

class ChangePasswordPage extends StatefulWidget {
  final UserProfile profile;
  final int id;

  const ChangePasswordPage({
    super.key,
    required this.profile,
    required this.id,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPassword1Controller;
  late TextEditingController newPassword2Controller;

  bool isSubmitting = false;
  Map<String, dynamic>? errors;

  @override
  void initState() {
    super.initState();
    oldPasswordController = TextEditingController();
    newPassword1Controller = TextEditingController();
    newPassword2Controller = TextEditingController();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPassword1Controller.dispose();
    newPassword2Controller.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    final request = context.read<CookieRequest>();

    setState(() {
      isSubmitting = true;
      errors = null;
    });

    final response = await request
        .post("$baseUrl/account/api/change_password/${widget.id}/", {
          "old_password": oldPasswordController.text,
          "new_password1": newPassword1Controller.text,
          "new_password2": newPassword2Controller.text,
        });

    if (response["status"] == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password changed successfully!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EditProfilePage(profile: widget.profile, id: widget.id),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
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

  InputDecoration webInputStyle(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF333333),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
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
        "Update Password",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget cancelButton() {
    return OutlinedButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EditProfilePage(profile: widget.profile, id: widget.id),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        elevation: 0,
        title: const Text("Change Password"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                const Text(
                  "Change Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                errorBox(),

                // Old Password
                const Text(
                  "Old Password",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: webInputStyle("Enter current password"),
                ),
                const SizedBox(height: 16),

                // New Password
                const Text(
                  "New Password",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: newPassword1Controller,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: webInputStyle("Enter new password"),
                ),
                const SizedBox(height: 16),

                // Confirm Password
                const Text(
                  "Confirm New Password",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: newPassword2Controller,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: webInputStyle("Re-enter new password"),
                ),

                const SizedBox(height: 24),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: cancelButton()),
                    const SizedBox(width: 12),
                    Expanded(child: saveButton()),
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
