import 'package:flutter/material.dart';

class CircleBottomNavigationBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    double x = size.width;
    double y = size.height;

    double startX = x * 0.02;
    double startY = y * 0.1;

    final path = Path();
    path.moveTo(startX, startY);
    path.lineTo(x * 0.35, y * 0.9);
    path.quadraticBezierTo(x/2, y * 0.85, x - (x * 0.35), y * 0.9);
    path.lineTo(x - startX, startY);
    path.quadraticBezierTo(x/2, -y * 0.09, startX, startY);
    return path;
  }

  @override
  bool shouldReclip(CircleBottomNavigationBarClipper oldClipper) => false;

}