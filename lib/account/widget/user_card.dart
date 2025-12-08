import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/account/models/user_profile.dart';
import 'package:nobarpedia_mobile/account/screens/admin_edit_profile_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:nobarpedia_mobile/config.dart';

class UserCard extends StatelessWidget {
  final UserProfile userData;
  final CookieRequest request;
  final VoidCallback onRefresh;

  const UserCard({
    super.key,
    required this.userData,
    required this.request,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final int userId = userData.id;
    final String username = userData.username;
    final bool isAdmin = userData.isAdmin;
    final String profilePictureUrl = userData.profilePictureUrl;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT SIDE: Avatar + Username
          // pake Expanded biar ga overflow klo namanya panjang
          Expanded(
            child: Row(
              children: [
                // Profile Picture
                Center(
                  child: CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        "$baseUrl/$profilePictureUrl",
                      ),
                      onBackgroundImageError: (_, __) {},
                      backgroundColor: const Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Username
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isAdmin)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "(Admin)",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // RIGHT SIDE: Edit and Delete buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit Button
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.green),
                tooltip: 'Edit User',
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AdminEditProfilePage(currentUser: userData),
                    ),
                  );
                },
              ),

              // Delete Button
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: 'Delete User',
                onPressed: () => _showDeleteConfirmation(context, userId),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext parentContext,
    int userId,
  ) async {
    return showDialog<void>(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF333333),
          title: const Text(
            "Confirm Delete",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Are you sure you want to delete this profile? This cannot be undone.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog

                final response = await request.post(
                  "$baseUrl/account/api/delete_profile/$userId/",
                  {},
                );

                if (parentContext.mounted) {
                  if (response['status'] == true) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      const SnackBar(
                        content: Text("Profile deleted"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Call the callback to refresh the list in the parent widget
                    onRefresh();
                  } else {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(
                        content: Text(response['message'] ?? "Error"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
