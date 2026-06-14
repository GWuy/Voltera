import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthFooterLink extends StatelessWidget {
  final String label;
  final String linkText;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.label,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(linkText, style: AppTextStyles.link),
          ),
        ],
      ),
    );
  }
}
