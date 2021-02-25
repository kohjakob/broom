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
        return Color(0xFF2c3e50);
      case CustomColor.PURPLE:
        return Color(0xFF8e44ad);
      case CustomColor.BLUE:
        return Color(0xFF2980b9);
      case CustomColor.GREEN:
        return Color(0xFF27ae60);
      case CustomColor.RED:
        return Color(0xFFe74c3c);
      case CustomColor.ORANGE:
        return Color(0xFFe67e22);
      case CustomColor.YELLOW:
        return Color(0xFFf1c40f);
      case CustomColor.LIGHTGRAY:
        return Color(0xFF95a5a6);
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
