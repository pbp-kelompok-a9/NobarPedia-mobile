import 'package:flutter/material.dart';
import 'package:nobarpedia_mobile/config.dart';
import 'package:nobarpedia_mobile/join/models/JoinEntry.dart';

class JoinEntryCard extends StatelessWidget {
  final JoinEntry join;
  // final VoidCallback onTap;

  const JoinEntryCard({
    super.key,
    required this.join,
    // required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      child: InkWell(
        // onTap: onTap,
        child: Card(
          color: Color.fromRGBO(64, 64, 64, 255),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // // Thumbnail
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(6),
                //   child: Image.network(
                //     '$baseUrl/proxy-image/?url=${Uri.encodeComponent(join.thumbnail)}',
                //     height: 150,
                //     width: double.infinity,
                //     fit: BoxFit.cover,
                //     errorBuilder: (context, error, stackTrace) => Container(
                //       height: 150,
                //       color: Colors.grey[300],
                //       child: const Center(child: Icon(Icons.broken_image)),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 8),

                // // Title
                Text(
                  join.nobarPlaceName,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                Text(
                  join.nobarPlaceCity,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),
                ),
                const SizedBox(height: 4),

                // // Category
                // Text('Category: ${join.category}'),
                // const SizedBox(height: 6),

                // // Content preview
                // Text(
                //   join.description.length > 100
                //       ? '${join.description.substring(0, 100)}...'
                //       : join.description,
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   style: const TextStyle(color: Colors.black54),
                // ),
                // const SizedBox(height: 6),

                // // Featured indicator
                // if (join.isFeatured)
                //   const Text(
                //     'Featured',
                //     style: TextStyle(
                //       color: Colors.amber,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
