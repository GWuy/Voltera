import 'package:flutter/material.dart';

const _kTextDark = Color(0xFF0D0D0D);
const _kTextMid = Color(0xFF6B7280);

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 60, color: _kTextMid),
            SizedBox(height: 12),
            Text(
              'No listings found',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _kTextDark),
            ),
            SizedBox(height: 4),
            Text(
              'Try a different category or search',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: _kTextMid),
            ),
          ],
        ),
      ),
    );
  }
}
