import 'package:flutter/material.dart';

enum CustomColor {
  MIDNIGHT,
  PURPLE,
  BLUE,
  GREEN,
  RED,
  ORANGE,
  YELLOW,
  LIGHTGRAY
}

extension CustomColorExtensions on CustomColor {
  Color get material {
    switch (this) {
      case CustomColor.MIDNIGHT:
        //return Color(0xFF2c3e50);
        return Colors.blueGrey;
      case CustomColor.PURPLE:
        return Colors.purple.shade400;
      case CustomColor.BLUE:
        return Colors.blue.shade400;
      case CustomColor.GREEN:
        return Colors.lightGreen.shade400;
      case CustomColor.RED:
        return Colors.red.shade400;
      case CustomColor.ORANGE:
        return Colors.orange.shade400;
      case CustomColor.YELLOW:
        return Colors.amber.shade400;
      case CustomColor.LIGHTGRAY:
        return Colors.grey.shade400;
    }
  }

  String get name {
    switch (this) {
      case CustomColor.MIDNIGHT:
        return "Midnight";
      case CustomColor.PURPLE:
        return "Purple";
      case CustomColor.BLUE:
        return "Blue";
      case CustomColor.GREEN:
        return "Green";
      case CustomColor.RED:
        return "Red";
      case CustomColor.ORANGE:
        return "Orange";
      case CustomColor.YELLOW:
        return "Yellow";
      case CustomColor.LIGHTGRAY:
        return "Lightgray";
    }
  }
}
