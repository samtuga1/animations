import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0x0ff2d2fa),
      body: Container(
        color: const Color(0xff2d2f41),
        alignment: Alignment.center,
        child: SizedBox(
          height: 300,
          width: 300,
          child: Transform.rotate(
            angle: -pi / 2,
            child: CustomPaint(
              painter: ClockPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()..color = const Color(0xff444974);

    var outlineBrush = Paint()
      ..color = const Color(0xffeaecff)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16;

    var centerFillBrush = Paint()..color = const Color(0xffeaecff);

    var secHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5
      ..color = Colors.orange[300]!;

    var minHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Colors.orange[300]!
      ..strokeCap = StrokeCap.round
      ..shader =
          const RadialGradient(colors: [Color(0xff748ef6), Color(0xff77ddff)])
              .createShader(Rect.fromCircle(
        center: center,
        radius: radius,
      ));

    var hourHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..color = Colors.orange[300]!
      ..shader =
          const RadialGradient(colors: [Color(0xffea74ab), Color(0xff77ddff)])
              .createShader(Rect.fromCircle(
        center: center,
        radius: radius,
      ));

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outlineBrush);

    var secHandX =
        (radius - 60) * cos((dateTime.second * 6) * pi / 180) + centerX;
    var secHandY =
        (radius - 60) * sin((dateTime.second * 6) * pi / 180) + centerY;
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    var minHandX =
        (radius - 80) * cos((dateTime.minute * 6) * pi / 180) + centerX;
    var minHandY =
        (radius - 80) * sin((dateTime.minute * 6) * pi / 180) + centerY;
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var hourHandX = (radius - 100) *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180) +
        centerX;
    var hourHandY = (radius - 100) *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180) +
        centerY;
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    canvas.drawCircle(center, 16, centerFillBrush);

    var dashBrush = Paint()
      ..color = const Color(0xffeaecff)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    var outerCircleRadius = radius;
    var innerCircelRadius = radius - 14;
    for (double i = 0; i <= 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerY + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircelRadius * cos(i * pi / 180);
      var y2 = centerY + innerCircelRadius * sin(i * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
