import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/account/models/user_profile.dart';
import 'package:nobarpedia_mobile/account/screens/admin_account_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:nobarpedia_mobile/config.dart';

class AdminEditProfilePage extends StatefulWidget {
  final UserProfile currentUser;

  const AdminEditProfilePage({super.key, required this.currentUser});

  @override
  State<AdminEditProfilePage> createState() => _AdminEditProfilePageState();
}

class _AdminEditProfilePageState extends State<AdminEditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _fullnameController;
  late TextEditingController _bioController;
  late TextEditingController _passwordController;

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _profilePictureUrl;
  String _displayUsername = "";

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _usernameController = TextEditingController(
      text: widget.currentUser.username,
    );
    _emailController = TextEditingController(text: widget.currentUser.email);
    _fullnameController = TextEditingController(
      text: widget.currentUser.fullname,
    );
    _bioController = TextEditingController(text: widget.currentUser.bio);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _fullnameController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final request = context.read<CookieRequest>();
    setState(() => _isSubmitting = true);

    try {
      // Prepare data map
      final Map<String, dynamic> data = {
        "username": _usernameController.text,
        "email": _emailController.text,
        "fullname": _fullnameController.text,
        "bio": _bioController.text,
      };

      // Only add password if user typed something (to match HTML behavior)
      if (_passwordController.text.isNotEmpty) {
        data["password"] = _passwordController.text;
      }

      final response = await request.post(
        "$baseUrl/account/api/admin/edit_profile/${widget.currentUser.id}/",
        data,
      );

      if (mounted) {
        if (response['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully!"),
              backgroundColor: Color(0xFF2CAC5C),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminAccountPage()),
          ); // Return true to indicate refresh needed
        } else {
          // Handle form errors
          String errorMessage = "Failed to update.";
          if (response['message'] is Map) {
            errorMessage = response['message'].values.join(
              '\n',
            ); // Flatten error map
          } else if (response['message'] is String) {
            errorMessage = response['message'];
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: const Color(0xFFE53E3E),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: const Color(0xFFE53E3E),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // --- STYLING HELPERS ---
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2CAC5C)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminAccountPage()),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32), // px-10 py-8 approx
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    "Edit Profile: $_displayUsername",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You are editing as an Admin.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Avatar
                  Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.green,
                      child: CircleAvatar(
                        radius: 52,
                        backgroundImage: NetworkImage(
                          "$baseUrl/$_profilePictureUrl",
                        ),
                        onBackgroundImageError: (_, __) {},
                        backgroundColor: const Color(0xFF333333),
                      ),
                    ),
                  ),
                  // NOTE: File upload requires MultipartRequest, simpler to stick to text edit for now
                  const SizedBox(height: 24),

                  // Inputs
                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration("Username"),
                    validator: (v) =>
                        v!.isEmpty ? "Username cannot be empty" : null,
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration("Email"),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _fullnameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration("Fullname"),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _bioController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: _buildInputDecoration("Bio"),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration("New Password").copyWith(
                      hintText: "Leave blank to keep unchanged",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminAccountPage(),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFF333333),
                            foregroundColor: const Color(0xFFCCCCCC),
                            side: const BorderSide(color: Color(0xFF666666)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2CAC5C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF2CAC5C),
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Update Profile"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
