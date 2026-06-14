import 'package:flutter/material.dart';

import '../providers/home_provider.dart';

const _kPrimary = Color(0xFF3D3DC6);
const _kTextDark = Color(0xFF0D0D0D);
const _kTextMid = Color(0xFF6B7280);

class HomeErrorState extends StatelessWidget {
  final HomeProvider homeProvider;

  const HomeErrorState({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 60, color: _kTextMid),
            const SizedBox(height: 12),
            const Text(
              'Could not load posts',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _kTextDark),
            ),
            const SizedBox(height: 4),
            Text(
              homeProvider.error ?? '',
              style: const TextStyle(fontSize: 12, color: _kTextMid),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: homeProvider.refresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
