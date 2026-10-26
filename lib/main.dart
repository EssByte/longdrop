import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: LongdropApp()));
}

class LongdropApp extends StatelessWidget {
  const LongdropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Longdrop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
