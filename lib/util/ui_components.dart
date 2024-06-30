import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoldText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const BoldText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.color = Colors.black
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        height: .1,
      ),
    );
  }
}

class NormalText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const NormalText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.color = Colors.black
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        height: .1,
      ),
    );
  }
}
