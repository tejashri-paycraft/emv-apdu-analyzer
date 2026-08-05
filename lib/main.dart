import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const EMVAnalyzerApp());
}

class EMVAnalyzerApp extends StatelessWidget {
  const EMVAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const HomeScreen(),
    );
  }
}
