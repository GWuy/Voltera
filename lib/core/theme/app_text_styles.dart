import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralized typography for the Voltera app.
///
/// Provides pre-built [TextStyle] constants for consistent text rendering.
abstract final class AppTextStyles {
  // ── Headings ──────────────────────────────────────────────────────────────
  static const TextStyle heading1 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    color: AppColors.textDark,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textMid,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    color: AppColors.textMid,
  );

  static const TextStyle captionSmall = TextStyle(
    fontSize: 12,
    color: AppColors.textMid,
  );

  // ── Labels ────────────────────────────────────────────────────────────────
  static const TextStyle fieldLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle fieldLabelSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // ── Input ─────────────────────────────────────────────────────────────────
  static const TextStyle inputText = TextStyle(
    fontSize: 15,
    color: AppColors.textDark,
  );

  static const TextStyle inputHint = TextStyle(
    fontSize: 14,
  );

  // ── Links / Actions ───────────────────────────────────────────────────────
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle linkDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  // ── Price ─────────────────────────────────────────────────────────────────
  static const TextStyle price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  // ── Button ────────────────────────────────────────────────────────────────
  static const TextStyle button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  AppTextStyles._();
}
