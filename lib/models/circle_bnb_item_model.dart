import 'package:flutter/material.dart';

class CircleBNBItem {
  final String title;
  final IconData icon;
  final TextStyle? textStyle;
  final Color? iconColor;

  CircleBNBItem({
    required this.title,
    required this.icon,
    this.textStyle,
    this.iconColor,
  });
}