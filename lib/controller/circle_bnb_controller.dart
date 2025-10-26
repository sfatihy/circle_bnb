import 'dart:math';

import 'package:flutter/material.dart';

import '../enums/navigation_style.dart';
import '../models/circle_bnb_model.dart';
import '../widget/circle_bnb_widget.dart';

class CircleBnbController {
  // --- State Variables (ValueNotifiers) ---
  // These notify listeners to rebuild the UI when their values change.

  /// The current rotation angle of the circular menu in radians.
  final data = ValueNotifier<double>(0.0);
  /// The index of the item currently at the top (active).
  final topIndex = ValueNotifier<int>(0);
  /// Tracks if the drag gesture is finished to trigger animations.
  final isDone = ValueNotifier<bool>(true);
  /// Toggles between linear and circular navigation styles.
  final isLinearLayout = ValueNotifier<bool>(false);

  // --- Widget Properties ---

  /// Reference to the parent CircleBNB widget to access its properties.
  final CircleBNB widget;

  // --- Calculated Properties ---

  /// Geometric model for calculating item positions on the circle.
  final CircleBNBModel circleBNB;
  /// List of target rotation angles for each item.
  final List<double> angleListPi;
  /// List of angles used for detecting item transitions during drag.
  final List<double> angleListPi2;
  /// List of colors for the navigation items.
  final List<Color> colorList;

  // --- Internal State ---

  /// Stores the starting details of a drag gesture.
  late DragStartDetails _detailsVar;

  /// Constructor to initialize the controller.
  CircleBnbController(this.widget) :
    circleBNB = CircleBNBModel(widget.items.length),
    angleListPi = CircleBNBModel(widget.items.length).angleListPi,
    angleListPi2 = CircleBNBModel(widget.items.length).angleListPi2,
    colorList = widget.colorList ??
      [
        Colors.cyan.shade100,
        Colors.blue,
        Colors.green.shade200,
        Colors.purpleAccent
      ]
    {
      isLinearLayout.value = widget.navigationStyle == NavigationStyle.linear;
    }

  /// Disposes the ValueNotifiers to free up resources.
  void dispose() {
    data.dispose();
    topIndex.dispose();
    isDone.dispose();
    isLinearLayout.dispose();
  }

  /// Handles the rotation logic during a horizontal drag gesture.
  void cyclingMechanic(DragUpdateDetails details) {
    // counter-clockwise drag
    if (details.localPosition.dx.floorToDouble() > _detailsVar.localPosition.dx.floorToDouble()) {
      data.value = data.value + widget.dragSpeed;
    }
    // clockwise drag
    else {
      data.value = data.value - widget.dragSpeed;
    }

    final itemCount = widget.items.length;
    final step = 2 * pi / itemCount; // 2 * pi

    // Calculate index based on the rotation angle.
    // The angle is divided by the step angle for each item, and rounded to the nearest whole number.
    // This gives the index of the item that is closest to the top position.
    final rawIndex = -data.value / step;
    final snappedIndex = rawIndex.round();

    // Normalize the index to ensure it's within the valid range [0, itemCount - 1].
    // The modulo operator (%) handles wrapping around, and adding itemCount before the modulo
    // ensures the result is always positive.
    topIndex.value = (snappedIndex % itemCount + itemCount) % itemCount;
  }

  /// Rotates the menu to the selected item when it's clicked.
  void clickState(int clickedIndex) {
    final itemCount = widget.items.length;
    final step = 2 * pi / itemCount;

    final canonicalAngle = -clickedIndex * step;
    final k = ((data.value - canonicalAngle) / (2 * pi)).round();
    final targetAngle = canonicalAngle + k * (2 * pi);

    data.value = targetAngle;
    topIndex.value = clickedIndex;
    widget.onChangeIndex(topIndex.value); // Notify the parent widget of the index change.

    // Switch to linear layout if the style is set to linear.
    if (widget.navigationStyle == NavigationStyle.linear) {
      isLinearLayout.value = true;
    }
  }

  /// Called when a drag gesture starts.
  void onDragStart(DragStartDetails details) {
    isDone.value = false; // Mark dragging as active.
    _detailsVar = details; // Store start position.
  }

  /// Called when a drag gesture ends.
  void onDragEnd(DragEndDetails details) {
    isDone.value = true; // Mark dragging as finished.
    // Snap the wheel to the final top item's position.
    final itemCount = widget.items.length;
    final step = 2 * pi / itemCount;
    final rawIndex = -data.value / step;
    final snappedIndex = rawIndex.round();

    data.value = -snappedIndex * step;
    widget.onChangeIndex(topIndex.value);

    // Switch to linear layout if the style is set to linear.
    if (widget.navigationStyle == NavigationStyle.linear) {
      isLinearLayout.value = true;
    }
  }

  /// Handles tap on the center text, resetting the wheel to the first item.
  void onCenterTextTap() {
    data.value = angleListPi[0]; // Reset angle.
    topIndex.value = 0; // Reset index.
    widget.onChangeIndex(topIndex.value);

    // Switch to linear layout if the style is set to linear.
    if (widget.navigationStyle == NavigationStyle.linear) {
      isLinearLayout.value = true;
    }
  }
}
