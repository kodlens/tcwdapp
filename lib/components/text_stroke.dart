import 'package:flutter/material.dart';

class TextStroke extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color strokeColor;
  final double strokeWidth;
  final double textFontSize;
  final FontWeight textFontWeight;

  TextStroke({
    required this.text,
    required this.textFontSize,
    required this.textColor,
    required this.strokeColor,
    required this.strokeWidth,
    required this.textFontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Stroke
        Text(
          text,
          style: TextStyle(
            fontWeight: textFontWeight,
            fontSize: textFontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Solid text
        Text(
          text,
          style: TextStyle(
            fontSize: textFontSize,
            fontWeight: textFontWeight,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
