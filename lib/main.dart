import 'package:flutter/material.dart';

import 'routes/app_router.dart';

void main() {
  runApp(const VolteraApp());
}

class VolteraApp extends StatelessWidget {
  const VolteraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Voltera',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
