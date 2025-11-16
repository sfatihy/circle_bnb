import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/circle_bnb_controller.dart';

import '../enums/navigation_style.dart';

import '../models/circle_bnb_item_model.dart';

import '../widget/circular_navigation_widget.dart';
import '../widget/linear_navigation_widget.dart';

@immutable
class CircleBNB extends StatefulWidget {

  /// The size of the widget. If not provided, it will be calculated automatically.
  final Size size;

  /// The list of colors for the background gradient. Must contain 4 colors.
  final List<Color>? colorList;

  /// The speed of the dragging animation.
  final double dragSpeed;

  /// The list of items to be displayed in the navigation bar. Must contain at least 3 items.
  final List<CircleBNBItem> items;

  /// A callback function that is called when the selected index changes.
  final Function(int index) onChangeIndex;

  /// The style of the navigation bar. Can be `NavigationStyle.linear` or `NavigationStyle.circular`.
  final NavigationStyle navigationStyle;

  /// The number of items to display when `navigationStyle` is `NavigationStyle.linear`.
  /// Must be an odd number between 3 and 5.
  final int? linearItemCount;

  /// Whether to show the icon of the selected item.
  final bool showIconWhenSelected;

  /// Whether to show the icons of unselected items.
  final bool showIconWhenUnselected;

  /// Whether to show the text of the selected item.
  final bool showTextWhenSelected;

  /// Whether to show the text of unselected items.
  final bool showTextWhenUnselected;

  /// The color of the selected item's icon.
  final Color? selectedIconColor;

  /// The text style for the selected item's label.
  final TextStyle? selectedTextStyle;

  /// The color of unselected items' icons.
  final Color? unselectedIconColor;

  /// The text style for unselected items' labels.
  final TextStyle? unselectedTextStyle;

  /// The background color of the widget as a circular.
  final Color? circularBackgroundColor;

  /// The background color of the widget as a linear.
  final Color? linearBackgroundColor;


  const CircleBNB({
    super.key,
    this.size = Size.zero,
    this.colorList,
    required this.dragSpeed,
    required this.items,
    required this.onChangeIndex,
    this.navigationStyle = NavigationStyle.linear,
    this.linearItemCount = 3,
    this.showIconWhenSelected = true,
    this.showIconWhenUnselected = true,
    this.showTextWhenSelected = true,
    this.showTextWhenUnselected = true,
    this.selectedIconColor,
    this.selectedTextStyle,
    this.unselectedIconColor,
    this.unselectedTextStyle,
    this.circularBackgroundColor,
    this.linearBackgroundColor,
  }) : assert(items.length >= 3, 'items must contain more than 3 elements.'),
       assert(colorList == null || colorList.length == 4, 'colorList must be null or have more than 4 elements.'),
       assert(linearItemCount == null || (linearItemCount % 2 == 1 && linearItemCount <= 5 && linearItemCount <= items.length), 'linearItemCount must be an odd number, no more than 5 and not greater than the number of items.'),
       assert(linearItemCount == null || !(navigationStyle == NavigationStyle.linear && linearItemCount > items.length), 'linearItemCount cannot be greater than the number of items when using linear navigation style.'),
       assert(showIconWhenSelected || showTextWhenSelected, 'showIconWhenSelected and showTextWhenSelected cannot both be false.'),
       assert(showIconWhenUnselected || showTextWhenUnselected, 'showIconWhenUnselected and showTextWhenUnselected cannot both be false.');

  @override
  State<CircleBNB> createState() => _CircleBNBState();
}

class _CircleBNBState extends State<CircleBNB> {
  late final CircleBnbController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      _initializeController();
    }
  }

  @override
  void didUpdateWidget(CircleBNB oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinitialize controller when items count changes
    if (oldWidget.items.length != widget.items.length) {
      // Store the current top index before disposing
      final currentIndex = _controller.topIndex.value;

      // Dispose old controller
      _controller.dispose();

      // Reinitialize with new item count
      _initializeController();

      // Reset topIndex to a safe value if it's out of bounds
      if (currentIndex >= widget.items.length) {
        _controller.topIndex.value = 0;
        _controller.data.value = 0.0;
        widget.onChangeIndex(0);
      } else {
        _controller.topIndex.value = currentIndex;
        // Recalculate the data angle for the current index
        final step = 2 * pi / widget.items.length;
        _controller.data.value = -currentIndex * step;
      }
    }
  }

  void _initializeController() {
    Size finalSize;
    if (widget.size == Size.zero) {
      finalSize = Size(MediaQuery.of(context).size.width * 0.85, 215 + MediaQuery.of(context).padding.bottom * 0.75);
    } else {
      finalSize = widget.size;
    }

    final CircleBNB effectiveWidget = CircleBNB(
      key: widget.key,
      size: finalSize,
      colorList: widget.colorList,
      dragSpeed: widget.dragSpeed,
      items: widget.items,
      onChangeIndex: widget.onChangeIndex,
      navigationStyle: widget.navigationStyle,
      linearItemCount: widget.linearItemCount,
      showIconWhenSelected: widget.showIconWhenSelected,
      showIconWhenUnselected: widget.showIconWhenUnselected,
      showTextWhenSelected: widget.showTextWhenSelected,
      showTextWhenUnselected: widget.showTextWhenUnselected,
      selectedIconColor: widget.selectedIconColor,
      selectedTextStyle: widget.selectedTextStyle,
      unselectedIconColor: widget.unselectedIconColor,
      unselectedTextStyle: widget.unselectedTextStyle,
      circularBackgroundColor: widget.circularBackgroundColor,
      linearBackgroundColor: widget.linearBackgroundColor,
    );

    _controller = CircleBnbController(effectiveWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.isLinearLayout,
      builder: (context, isLinear, child) {
        return isLinear
          ? LinearNavigationWidget(controller: _controller)
          : CircularNavigationWidget(controller: _controller);
      },
    );
  }
}