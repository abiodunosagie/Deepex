import 'package:flutter/material.dart';

class GiftCardScreen extends StatelessWidget {
  const GiftCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gift Card Redemption')),
      body: const Center(child: Text('Gift Card Redemption Screen')),
    );
  }
}
