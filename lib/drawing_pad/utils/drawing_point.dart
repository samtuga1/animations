import 'package:flutter/material.dart';

class DrawingPoint {
  int id;
  double width;
  Color color;
  List<Offset> offsets;

  DrawingPoint({
    this.id = -1,
    this.width = 2,
    this.color = Colors.black,
    this.offsets = const [],
  });

  DrawingPoint copyWith({List<Offset>? offsets}) {
    return DrawingPoint(
      color: color,
      offsets: offsets ?? this.offsets,
      width: width,
      id: id,
    );
  }
}
