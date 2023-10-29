import 'package:animations/clock/home.dart';
import 'package:flutter/material.dart';

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: ClockScreen(),
    );
  }
}
