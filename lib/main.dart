import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const LongdropApp());
}

class LongdropApp extends StatelessWidget {
  const LongdropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Longdrop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
