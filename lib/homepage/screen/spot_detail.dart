import '../models/spot_entry.dart';
import 'package:flutter/material.dart';

class SpotDetailPage extends StatelessWidget {
  final SpotEntry spot;

  const SpotDetailPage({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spot Detail'),
        backgroundColor: const Color.fromARGB(255, 17, 114, 17),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail image
            if (spot.thumbnail.isNotEmpty)
              Image.network(
                'http://localhost:8000/proxy-image/?url=${Uri.encodeComponent(spot.thumbnail)}',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured badge
                  // if (product.isFeatured)
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 12.0, vertical: 6.0),
                  //     margin: const EdgeInsets.only(bottom: 12.0),
                  //     decoration: BoxDecoration(
                  //       color: Colors.amber,
                  //       borderRadius: BorderRadius.circular(20.0),
                  //     ),
                  //     child: const Text(
                  //       'Featured',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 12,
                  //       ),
                  //     ),
                  //   ),

                  // Title
                  Text(
                    spot.name,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Brand
                  // Text(
                  //   spot.brand,
                  //   style: const TextStyle(
                  //     fontSize: 20.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 8),
                  
                  const Divider(height: 32),

                  // Address
                  Text(
                    spot.address,
                    style: const TextStyle(
                      fontSize: 16.0,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}