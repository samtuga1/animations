import 'dart:math';

import 'package:animations/drawing_pad/widgets/color_picker_widget.dart';
import 'package:animations/drawing_pad/utils/drawing_point.dart';
import 'package:flutter/material.dart';

class DrawingPadScreen extends StatefulWidget {
  const DrawingPadScreen({super.key});

  @override
  State<DrawingPadScreen> createState() => _DrawingPadScreenState();
}

class _DrawingPadScreenState extends State<DrawingPadScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeAnimationController;

  @override
  void initState() {
    _shakeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener(_updateStatus);
    super.initState();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _shakeAnimationController.reset();
    }
  }

  // to keep the sttate of the current selected color
  Color _selectedColor = Colors.black;

  // to keep track of the slider level
  double _drawingWidth = 2;

  final List<DrawingPoint> _drawingPoints = [];
  List<DrawingPoint> _historyDrawingPoint = [];

  DrawingPoint? _currentDrawingPoint;

  bool _activateErasor = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimationController.drive(
        CurveTween(curve: Curves.easeInToLinear),
      ),
      builder: (context, child) {
        const shakeCount = 3;
        const shakeOffset = 3;

        final sineValue =
            sin(shakeCount * 2 * pi * _shakeAnimationController.value);
        return Transform.translate(
          offset: Offset(sineValue * shakeOffset, 0),
          child: child,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            GestureDetector(
              onPanStart: _onPanStart,
              onPanEnd: (details) {
                _currentDrawingPoint = null;
              },
              onPanUpdate: _onPanUpdate,
              child: CustomPaint(
                painter: _DrawingPadPainter(_drawingPoints),
                child: SizedBox(
                  // color: Colors.transparent,
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 20,
              left: 0,
              right: 0,
              child: ColorPicker(
                onColorChange: (color) {
                  _selectedColor = color;
                  setState(() {});
                },
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 80,
              bottom: MediaQuery.paddingOf(context).bottom + 80,
              right: 0,
              child: RotatedBox(
                  quarterTurns: 3,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeOutCubic,
                    child: Slider.adaptive(
                      key: ValueKey(_selectedColor),
                      min: 1,
                      max: 30,
                      activeColor: _selectedColor,
                      inactiveColor: Colors.grey,
                      value: _drawingWidth,
                      onChanged: (val) {
                        _drawingWidth = val;
                        setState(() {});
                      },
                    ),
                  )),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom + 15,
            right: 10,
            left: 10,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor:
                    _activateErasor ? Colors.teal[900] : Colors.transparent,
                child: IconButton(
                  color: _activateErasor ? Colors.white : Colors.black,
                  onPressed: () {
                    _activateErasor = !_activateErasor;
                    setState(() {});
                  },
                  icon: const Icon(Icons.cleaning_services),
                ),
              ),
              const Spacer(),
              FloatingActionButton(
                backgroundColor: Colors.teal[900],
                onPressed: () {
                  if (_drawingPoints.isEmpty) {
                    _shakeAnimationController.forward();
                    return;
                  }
                  _drawingPoints.removeLast();
                  setState(() {});
                },
                child: const Icon(
                  Icons.undo,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              FloatingActionButton(
                backgroundColor: Colors.teal[900],
                onPressed: () {
                  if (_drawingPoints.length == _historyDrawingPoint.length) {
                    _shakeAnimationController.forward();
                    return;
                  }

                  _drawingPoints.add(
                    _historyDrawingPoint[_drawingPoints.length],
                  );

                  setState(() {});
                },
                child: const Icon(
                  Icons.redo,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPanStart(DragStartDetails details) {
    // get the current offset of the pointer
    final offset = details.localPosition;

    // create a drawing point and add the current pointer offset to
    // list of offsets of this drawing point
    _currentDrawingPoint = DrawingPoint(
      width: _drawingWidth,
      id: DateTime.now().microsecondsSinceEpoch,
      offsets: [offset],
      color: _activateErasor ? Colors.white : _selectedColor,
    );

    if (_currentDrawingPoint == null) return;

    _drawingPoints.add(_currentDrawingPoint!);

    // now create the history of drawing points to help in undo and redo
    _historyDrawingPoint = List.from(_drawingPoints);

    setState(() {});
  }

  _onPanUpdate(DragUpdateDetails details) {
    // get the current offset of the pointer
    final offset = details.localPosition;

    _currentDrawingPoint!.copyWith(
      offsets: _currentDrawingPoint!.offsets..add(offset),
    );

    // set our last drawing point to be the current one
    // for the custom painter to be aware of it

    _drawingPoints.last = _currentDrawingPoint!;

    // update the history of drawing points
    _historyDrawingPoint = List.from(_drawingPoints);

    setState(() {});
  }

  @override
  void dispose() {
    _shakeAnimationController.removeStatusListener(_updateStatus);
    _shakeAnimationController.dispose();
    super.dispose();
  }
}

class _DrawingPadPainter extends CustomPainter {
  final List<DrawingPoint> _drawingPoints;

  _DrawingPadPainter(this._drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in _drawingPoints) {
      final paint = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = point.width
        ..color = point.color
        ..isAntiAlias = true;

      for (int i = 0; i < point.offsets.length; i++) {
        // check if is not the last offset
        bool notLastOffset = i != point.offsets.length - 1;

        if (notLastOffset) {
          Offset current = point.offsets[i];
          Offset next = point.offsets[i + 1];

          canvas.drawLine(current, next, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
