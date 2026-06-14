import 'package:flutter/material.dart';

const _kPrimary = Color(0xFF3D3DC6);
const _kTextDark = Color(0xFF0D0D0D);

class RecommendationsHeader extends StatelessWidget {
  const RecommendationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recommendations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _kTextDark,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'View all',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _kPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
