import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/homepage/screen/spot_form.dart';
import '../models/spot_entry.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class SpotEntryCard extends StatelessWidget {
  final SpotEntry spot;
  final VoidCallback onTap;
  final Future<void> Function()? onDelete;
  
  const SpotEntryCard({
    super.key,
    required this.spot,
    required this.onTap,
    this.onDelete,
  });

  String formatDate(DateTime date) {
    const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    return "${date.day} ${months[date.month - 1]}";
  }

  Future<void> _deleteSpot(BuildContext context, CookieRequest request) async {
    // Konfirmasi delete
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Spot'),
          content: Text('Are you sure you want to delete "${spot.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final response = await request.postJson(
        "$baseUrl/delete-spot-flutter/${spot.id}/",
        jsonEncode({
          "username": request.jsonData['username'],
        }),
      );

      if (context.mounted) {
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Spot deleted successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          // Panggil callback untuk refresh list
          if (onDelete != null) {
            await onDelete!();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? "Failed to delete spot"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _editSpot(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SpotFormPage(spotToEdit: spot,)));
  }


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    final currentUsername = request.jsonData['username'];
    final isOwner = request.loggedIn && 
                    currentUsername != null && 
                    currentUsername == spot.hostUsername;

    return Container(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          color: Colors.white,
          elevation: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: AspectRatio(
                    aspectRatio: 16/9,
                    child: Image.network(
                      '$baseUrl/proxy-image/?url=${Uri.encodeComponent(spot.thumbnail)}',
                      height: 94,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 94,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.broken_image)),
                      ),
                    ),
                  ),
                  
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color:Colors.green, width: 1.5),
                      ),
                      child: Text(
                        "${spot.homeTeam} vs ${spot.awayTeam}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // === Nama tempat ===
                        Flexible(child: Text(
                          spot.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )
                        )),

                        // === Tanggal dan waktu ===
                        Text(
                          "${formatDate(spot.date)} | ${spot.time.substring(0,5)}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color:Colors.black,
                          ),
                        )
                      ],
                    ),

                    // City
                      Text(
                        spot.city,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (isOwner) ...[
                            const SizedBox(width: 16),
                            IconButton(
                              // Aksi edit
                              onPressed: () => _editSpot(context),
                              icon: const Icon(Icons.edit, color: Colors.green, size: 26),
                            ),

                            IconButton(
                              // Aksi delete
                              onPressed: () => _deleteSpot(context, request),
                              icon: const Icon(Icons.delete, color: Colors.red, size: 26),
                            ),
                          ],
                          
                        ],
                      )





                  ],),
                ),

                

               

                

                


              ],
            ),
        ),
      ),
    );
  }
}