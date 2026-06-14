import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_banner.dart';

class LoginHeader extends StatelessWidget {
  final String title;
  final String? successMessage;

  const LoginHeader({
    super.key,
    this.title = 'Login Your\nAccount',
    this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(title, style: AppTextStyles.heading1),
        const SizedBox(height: 36),
        if (successMessage != null) ...[
          SuccessBanner(message: successMessage!),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
