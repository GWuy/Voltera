import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../favorite/presentation/providers/favorite_provider.dart';
import '../../data/models/post_response.dart';

const _kPrimary = Color(0xFF3D3DC6);
const _kSurface = Colors.white;
const _kTextDark = Color(0xFF0D0D0D);
const _kTextMid = Color(0xFF6B7280);

class PostCard extends StatelessWidget {
  final PostResponse post;
  final String Function(double?) formatPrice;

  const PostCard({super.key, required this.post, required this.formatPrice});

  @override
  Widget build(BuildContext context) {
    final isBattery = post.isBattery;
    final thumb = post.thumbnail;

    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: thumb != null
                    ? CachedNetworkImage(
                        imageUrl: thumb,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        placeholder: (ctx, url) => Container(
                          height: 180,
                          color: const Color(0xFFF3F4F6),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: _kPrimary,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (ctx, url, err) => Container(
                          height: 180,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(
                            Icons.image_not_supported_rounded,
                            color: _kTextMid,
                            size: 40,
                          ),
                        ),
                      )
                    : Container(
                        height: 180,
                        color: const Color(0xFFF3F4F6),
                        child: Center(
                          child: Icon(
                            isBattery
                                ? Icons.battery_full_rounded
                                : Icons.directions_car_rounded,
                            size: 60,
                            color: _kTextMid,
                          ),
                        ),
                      ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Consumer<FavoriteProvider>(
                  builder: (context, provider, child) {
                    final isFav = provider.isFavorite(post.postId ?? 0);
                    return GestureDetector(
                      onTap: () async {
                        final success = await provider.toggleFavorite(
                          post.postId ?? 0,
                          title: post.title,
                          price: post.price,
                          thumbnail: post.thumbnail,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? (isFav
                                          ? 'Removed from favorites'
                                          : 'Added to favorites')
                                    : 'Failed to update favorites',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: isFav ? Colors.red : _kTextMid,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isBattery ? const Color(0xFF059669) : _kPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isBattery
                            ? Icons.battery_charging_full_rounded
                            : Icons.directions_car_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isBattery ? 'Battery' : 'Car',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title ?? 'No title',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _kTextDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                if (isBattery && post.battery != null)
                  _buildBatteryDetails(post.battery!)
                else if (post.vehicle != null)
                  _buildCarDetails(post.vehicle!),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (post.location != null) ...[
                      const Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: _kTextMid,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          post.location!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _kTextMid,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ] else
                      const Spacer(),
                    Flexible(
                      child: Text(
                        formatPrice(post.price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _kPrimary,
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
    );
  }

  Widget _buildBatteryDetails(dynamic battery) {
    return Wrap(
      spacing: 12,
      children: [
        _PostDetail(
          icon: Icons.bolt_rounded,
          label: '${battery.voltage?.toStringAsFixed(0) ?? '--'} V',
        ),
        _PostDetail(
          icon: Icons.loop_rounded,
          label: '${battery.cycleCount ?? '--'} cycles',
        ),
        _PostDetail(
          icon: Icons.speed_rounded,
          label: '${battery.mileageCovered ?? '--'} km',
        ),
      ],
    );
  }

  Widget _buildCarDetails(dynamic vehicle) {
    return Wrap(
      spacing: 12,
      children: [
        _PostDetail(
          icon: Icons.branding_watermark_rounded,
          label: vehicle.brand ?? '--',
        ),
        _PostDetail(
          icon: Icons.calendar_today_rounded,
          label: '${vehicle.year ?? '--'}',
        ),
        if (vehicle.vehicleType != null)
          _PostDetail(
            icon: Icons.category_rounded,
            label: vehicle.vehicleType!,
          ),
      ],
    );
  }
}

class _PostDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PostDetail({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: _kTextMid),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: _kTextMid),
          ),
        ),
      ],
    );
  }
}
