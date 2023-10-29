import 'package:animations/drawing_pad/home.dart';
import 'package:flutter/material.dart';

class DrawingPad extends StatelessWidget {
  const DrawingPad({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: DrawingPadScreen(),
    );
  }
}
