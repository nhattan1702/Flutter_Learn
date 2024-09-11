import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  AppColors._internal();

  static AppColors _instance = AppColors._internal();

  factory AppColors() {
    return _instance;
  }

  static Random random = new Random();

  List<Color> colors = [
    Colors.red.shade100,
    Colors.teal,
    Colors.green,
    Colors.grey,
    matchaDark,
    matchaLight
  ];

  void getRandomColor() {
    default2 = colors[random.nextInt(colors.length)];
    default1 = colors[random.nextInt(colors.length)];
  }

  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Background colors
  static const Color matchaLight = Color.fromARGB(255, 193, 231, 181);
  static const Color matchaDark = Color.fromRGBO(86, 194, 91, 1);

  Color default2 = Colors.white;
  Color default1 = Colors.black;

  // Text colors
  static const Color textColor = Color(0xFF333333);
  static const Color secondaryTextColor = Color(0xFF757575);
}
