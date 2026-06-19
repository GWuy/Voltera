import 'package:flutter/material.dart';
import 'package:voltera/core/theme/app_colors.dart';

/// Social login buttons row (Google, Facebook, GitHub).
///
/// Extracted from login_screen to reduce file size and enable reuse.
/// Uses const constructors throughout — Flutter skips rebuild diffing.
class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialIconButton(icon: _GoogleIcon()),
        SizedBox(width: 16),
        _SocialIconButton(icon: _FacebookIcon()),
        SizedBox(width: 16),
        _SocialIconButton(icon: _GitHubIcon()),
      ],
    );
  }
}

// ── Social icon button container ────────────────────────────────────────────

class _SocialIconButton extends StatelessWidget {
  final Widget icon;
  const _SocialIconButton({required this.icon});

  static const _kShadowColor = Color(0x0A000000);
  static const _decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(14)),
    boxShadow: [
      BoxShadow(color: _kShadowColor, blurRadius: 8, offset: Offset(0, 2)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: _decoration.copyWith(
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Center(child: icon),
    );
  }
}

// ── Google Icon ─────────────────────────────────────────────────────────────

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(size: Size(26, 26), painter: _googlePainter);
  }
}

const _googlePainter = _GooglePainter();

class _GooglePainter extends CustomPainter {
  const _GooglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final colors = [
      AppColors.google,
      AppColors.googleRed,
      AppColors.googleYellow,
      AppColors.googleGreen,
    ];

    final center = Offset(w / 2, h / 2);
    final radius = w / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.18;

    final angles = [
      [-0.1, 1.3],
      [1.2, 1.3],
      [2.5, 1.3],
      [3.8, 1.4],
    ];
    for (int i = 0; i < 4; i++) {
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.7),
        angles[i][0],
        angles[i][1],
        false,
        paint,
      );
    }

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.4, whitePaint);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.5, h * 0.35, w * 0.5, h * 0.30),
      whitePaint,
    );

    paint
      ..color = AppColors.google
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.18;
    canvas.drawLine(Offset(w * 0.5, h * 0.5), Offset(w * 0.88, h * 0.5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Facebook Icon ───────────────────────────────────────────────────────────

class _FacebookIcon extends StatelessWidget {
  const _FacebookIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 28,
      height: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.facebook,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            'f',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

// ── GitHub Icon ─────────────────────────────────────────────────────────────

class _GitHubIcon extends StatelessWidget {
  const _GitHubIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(28, 28),
      painter: const _GitHubIconPainter(),
    );
  }
}

class _GitHubIconPainter extends CustomPainter {
  const _GitHubIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.github
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final r = w * 0.28;

    canvas.drawCircle(Offset(cx, cy), w / 2, paint);

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(cx, cy - r * 0.15), r, whitePaint);

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy + r * 0.85),
        width: r * 1.5,
        height: r * 1.2,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(bodyRect, whitePaint);

    final leftEar = Path()
      ..moveTo(cx - r * 0.7, cy - r * 0.9)
      ..lineTo(cx - r * 0.35, cy - r * 1.2)
      ..lineTo(cx - r * 0.05, cy - r * 0.85)
      ..close();
    canvas.drawPath(leftEar, whitePaint);

    final rightEar = Path()
      ..moveTo(cx + r * 0.7, cy - r * 0.9)
      ..lineTo(cx + r * 0.35, cy - r * 1.2)
      ..lineTo(cx + r * 0.05, cy - r * 0.85)
      ..close();
    canvas.drawPath(rightEar, whitePaint);

    final facePaint = Paint()
      ..color = AppColors.github
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.1), r * 0.12, facePaint);
    canvas.drawCircle(Offset(cx + r * 0.3, cy - r * 0.1), r * 0.12, facePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
