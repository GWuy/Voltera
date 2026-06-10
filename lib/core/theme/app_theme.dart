import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Pre-built [ThemeData] for the Voltera app.
///
/// Created once at app startup — no re-computation on rebuilds.
final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
);
