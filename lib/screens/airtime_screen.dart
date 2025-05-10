import 'package:flutter/material.dart';

class AirtimeScreen extends StatelessWidget {
  const AirtimeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Airtime Purchase')),
      body: const Center(child: Text('Airtime Purchase Screen')),
    );
  }
}
