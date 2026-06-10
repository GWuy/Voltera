import 'package:flutter/material.dart';

/// Centralized color palette for the Voltera app.
///
/// All color values are compile-time constants — no runtime computation.
/// Usage: `AppColors.primary` instead of `Color(0xFF3D3DC6)`.
abstract final class AppColors {
  // ── Brand ─────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF3D3DC6);
  static const Color primaryLight = Color(0xFF6C63FF);
  static const Color primaryDisabled = Color(0x993D3DC6); // 0.60 alpha

  // ── Primary with alpha (pre-computed, avoids runtime withValues) ────────
  static const Color primaryAlpha08 = Color(0x143D3DC6);
  static const Color primaryAlpha10 = Color(0x1A3D3DC6);
  static const Color primaryAlpha12 = Color(0x1F3D3DC6);
  static const Color primaryAlpha15 = Color(0x263D3DC6);
  static const Color primaryAlpha35 = Color(0x593D3DC6);
  static const Color primaryAlpha40 = Color(0x663D3DC6);
  static const Color primaryAlpha50 = Color(0x803D3DC6);

  // ── Surfaces ──────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Colors.white;
  static const Color fill = Color(0xFFF4F5F7);
  static const Color fillReadOnly = Color(0xFFEEEEF8);
  static const Color avatarBg = Color(0xFFF0F0F8);
  static const Color imagePlaceholder = Color(0xFFF3F4F6);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textDark = Color(0xFF0D0D0D);
  static const Color textMid = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFF34D399);
  static const Color successBanner = Color(0xFFECFDF5);
  static const Color successBorder = Color(0xFF6EE7B7);
  static const Color successText = Color(0xFF065F46);
  static const Color error = Colors.red;
  static const Color info = Color(0xFF0EA5E9);
  static const Color infoLight = Color(0xFF38BDF8);

  // ── Borders / Dividers ────────────────────────────────────────────────────
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFD1D5DB);
  static const Color divider = Color(0xFFE5E7EB);

  // ── Social brand colors ───────────────────────────────────────────────────
  static const Color google = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFEA4335);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleGreen = Color(0xFF34A853);
  static const Color facebook = Color(0xFF1877F2);
  static const Color github = Color(0xFF1B1F23);

  // ── Notification dot ──────────────────────────────────────────────────────
  static const Color notificationDot = Color(0xFFEF4444);

  AppColors._(); // prevent instantiation
}
