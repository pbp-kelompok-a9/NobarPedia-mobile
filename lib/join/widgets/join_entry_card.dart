import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/join/models/join_entry.dart';
import 'package:nobarpedia_mobile/join/screens/menu.dart';
import 'package:nobarpedia_mobile/join/widgets/joinlist_form.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'dart:convert';  

class JoinEntryCard extends StatelessWidget {
  final JoinEntry join;

  const JoinEntryCard({
    super.key,
    required this.join,
  });

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  join.nobarPlaceName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '🕐 ${join.nobarPlaceTime}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              join.nobarPlaceCity,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Status: ${join.status}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateJoinPage(
                          id: join.nobarPlaceId,
                          name: join.nobarPlaceName,
                          city: join.nobarPlaceCity,
                          status: join.status,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    final response = await request.postJson(
                      "$baseUrl/join/delete-flutter/${join.id}/",
                      jsonEncode({}),
                    );
                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Successfully deleted the entry!"),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JoinPage(mine: false),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Something went wrong, please try again.",
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}