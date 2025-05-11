// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // Wrap the entire app with ProviderScope
    const ProviderScope(
      child: App(),
    ),
  );
}
