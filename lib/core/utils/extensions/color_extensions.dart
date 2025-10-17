import 'package:flutter/material.dart';

extension ColorParsing on String {
  Color toColor() {
    final hexCode = replaceAll('#', '');
    try {
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (e) {
      return Colors.transparent;
    }
  }
}
