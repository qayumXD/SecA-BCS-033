import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const NumberGuessingGameApp());
}

class NumberGuessingGameApp extends StatelessWidget {
  const NumberGuessingGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Guessing Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
