// lib/screens/home_screen.dart
import 'package:deepex/constants/app_text.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: AppText.titleLarge('Welcome to Deepex'),
      ),
    );
  }
}
