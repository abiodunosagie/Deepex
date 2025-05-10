import 'package:flutter/material.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Purchase')),
      body: const Center(child: Text('Data Purchase Screen')),
    );
  }
}
