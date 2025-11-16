import 'dart:math';

import 'package:flutter/material.dart';

class CircleBottomNavigationBarClipper extends CustomClipper<Path> {
  final int itemCount;

  CircleBottomNavigationBarClipper({required this.itemCount});

  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);

    // Define the radii for the outer and inner circles of the ring (annulus).
    final outerRadius = size.height / 2;
    final innerRadius = size.height / 2 * 0.25;

    // Calculate the angle that each slice will occupy.
    final sweepAngle = (2 * pi) / itemCount;

    // Center the slice pointing "up" (-90 degrees or -pi/2).
    final startAngle = -pi / 2 - (sweepAngle / 2);
    final endAngle = startAngle + sweepAngle;

    // Calculate the corner points of the annulus sector.
    final innerStartPoint = Offset(
      center.dx + innerRadius * cos(startAngle),
      center.dy + innerRadius * sin(startAngle),
    );
    final outerEndPoint = Offset(
      center.dx + outerRadius * cos(endAngle),
      center.dy + outerRadius * sin(endAngle),
    );

    // Build the path
    path.moveTo(innerStartPoint.dx, innerStartPoint.dy); // 1. Start at top-left (inner radius)

    // 2. Draw the inner arc to the top-right point.
    path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      startAngle,
      sweepAngle,
      false,
    );

    // 3. Draw a straight line to the bottom-right point (outer radius).
    path.lineTo(outerEndPoint.dx, outerEndPoint.dy);

    // 4. Draw the outer arc back to the bottom-left point.
    path.arcTo(
      Rect.fromCircle(center: center, radius: outerRadius),
      endAngle,
      -sweepAngle,
      false,
    );

    // 5. Close the path, which draws a line back to the starting point.
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CircleBottomNavigationBarClipper oldClipper) => oldClipper.itemCount != itemCount;
}