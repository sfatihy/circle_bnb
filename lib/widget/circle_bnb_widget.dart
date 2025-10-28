import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/circle_bnb_controller.dart';

import '../enums/navigation_style.dart';

import '../models/circle_bnb_item_model.dart';

import '../widget/circular_navigation_widget.dart';
import '../widget/linear_navigation_widget.dart';

@immutable
class CircleBNB extends StatefulWidget {

  final Size size;
  final List<Color>? colorList;
  final double dragSpeed;
  final List<CircleBNBItem> items;
  final Function (int index) onChangeIndex;
  final NavigationStyle navigationStyle;
  final int? linearItemCount;
  final bool showIconWhenSelected;
  final bool showIconWhenUnselected;
  final bool showTextWhenSelected;
  final bool showTextWhenUnselected;
  final Color? selectedIconColor;
  final TextStyle? selectedTextStyle;
  final Color? unselectedIconColor;
  final TextStyle? unselectedTextStyle;

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
      );

      _controller = CircleBnbController(effectiveWidget);
    }
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