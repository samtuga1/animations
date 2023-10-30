import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  ColorPicker({
    super.key,
    required this.onColorChange,
  });

  OnColorChange onColorChange;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  // to keep the sttate of the current selected color
  Color _selectedColor = Colors.black;

  // colors to be selected
  final List<Color> _colors = [
    Colors.black,
    Colors.amber,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.green,
    Colors.cyan,
    Colors.purple,
    Colors.brown,
    Colors.lime,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _colors
          .map(
            (color) => GestureDetector(
              onTap: () {
                _selectedColor = color;
                widget.onColorChange.call(_selectedColor);
                setState(() {});
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: _selectedColor == color
                      ? const Border.fromBorderSide(
                          BorderSide(color: Colors.black, width: 3),
                        )
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 13,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

typedef OnColorChange = void Function(Color color);
