import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../favorite/presentation/providers/favorite_provider.dart';
import '../../../home/data/models/post_response.dart';

class CarListItemCard extends StatelessWidget {
  final PostResponse car;
  final VoidCallback onTap;

  const CarListItemCard({super.key, required this.car, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: car.thumbnail != null
                        ? CachedNetworkImage(
                            imageUrl: car.thumbnail!,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 100,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.title ?? 'No Name',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 16),
                          const SizedBox(width: 4),
                          Text('4.8',
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.speed,
                                  color: Colors.grey.shade400, size: 18),
                              const SizedBox(width: 4),
                              Text('${car.vehicle?.odo ?? 0} km',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          Text(
                            priceFormat.format(car.price ?? 0),
                            style: const TextStyle(
                              color: Color(0xFF3D3DC6),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Consumer<FavoriteProvider>(
                builder: (context, provider, _) {
                  final isFav = provider.isFavorite(car.postId ?? 0);
                  return GestureDetector(
                    onTap: () => provider.toggleFavorite(
                      car.postId ?? 0,
                      title: car.title,
                      price: car.price,
                      thumbnail: car.thumbnail,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
