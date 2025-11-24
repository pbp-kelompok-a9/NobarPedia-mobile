import 'package:flutter/material.dart';

import 'package:nobarpedia_mobile/join/models/NobarSpot.dart';

class MySpotsCard extends StatelessWidget {
  final NobarSpot spot;

  const MySpotsCard({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  spot.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '🕐 ${spot.time}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              spot.city,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                // COUNT AMOUNT OF JOINS
                'Joined: ${spot.joinedCount}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: Implement edit
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    // TODO: Implement delete
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
