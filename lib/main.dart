import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TxtCleanerApp());
}

class TxtCleanerApp extends StatelessWidget {
  const TxtCleanerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Cleaner & Splitter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'monospace',
      ),
      home: const HomeScreen(),
    );
  }
}
