import 'package:flutter/material.dart';
import 'package:houseworks/presentation/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp())
  );
}
