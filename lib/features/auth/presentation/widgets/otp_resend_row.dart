import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OtpResendRow extends StatelessWidget {
  final bool canResend;
  final int countdown;
  final VoidCallback onResend;

  const OtpResendRow({
    super.key,
    required this.canResend,
    required this.countdown,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        GestureDetector(
          onTap: canResend ? onResend : null,
          child: Text(
            canResend ? 'Resend' : 'Resend in ${countdown}s',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: canResend ? AppColors.primary : Colors.grey.shade400,
            ),
          ),
        ),
      ],
    );
  }
}
