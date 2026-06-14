import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class OtpSubtitle extends StatelessWidget {
  final String email;

  const OtpSubtitle({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.bodySmall.copyWith(height: 1.5),
        children: [
          const TextSpan(text: 'A 6-digit code has been sent to\n'),
          TextSpan(
            text: email,
            style: const TextStyle(
              color: Color(0xFF3D3DC6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
