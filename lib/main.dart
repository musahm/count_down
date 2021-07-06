import 'package:flutter/material.dart';
import 'package:showcase/core/themes/theme.dart';
import 'package:showcase/features/stopwatch/presentation/pages/stopwatch_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool isLightTheme = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch',
      themeMode: ThemeMode.dark,
      theme: lightTheme(),
      home: StopWatchPage(),
    );
  }
}
