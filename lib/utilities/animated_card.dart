import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedCard extends StatelessWidget {
  final String animationPath;

  const AnimatedCard({required this.animationPath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Lottie.asset(animationPath),
    );
  }
}
