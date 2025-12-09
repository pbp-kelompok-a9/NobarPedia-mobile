import 'package:flutter/material.dart';
import '../models/spot_entry.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class SpotEntryCard extends StatelessWidget {
  final SpotEntry spot;
  final VoidCallback onTap;

  const SpotEntryCard({
    super.key,
    required this.spot,
    required this.onTap,
  });

  String formatDate(DateTime date) {
    const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    return "${date.day} ${months[date.month - 1]}";
  }



  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color:Colors.green, width: 1.5),
                  ),
                  child: Text(
                    "${spot.homeTeam} vs ${spot.awayTeam}",
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
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Aksi join
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Detail",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    if (request.loggedIn) ...[
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          // Aksi edit
                        },
                        icon: const Icon(Icons.edit, color: Colors.green, size: 26),
                      ),

                      IconButton(
                        onPressed: () {
                          // Aksi delete
                        },
                        icon: const Icon(Icons.delete, color: Colors.red, size: 26),
                      ),
                    ],
                    
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}