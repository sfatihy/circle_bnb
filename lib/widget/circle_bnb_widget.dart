import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/circle_bnb_controller.dart';

import '../enums/navigation_style.dart';

import '../models/circle_bnb_item_model.dart';

import '../widget/circular_navigation_widget.dart';
import '../widget/linear_navigation_widget.dart';

class CircleBNB extends StatefulWidget {

  final Size size;
  final List<Color>? colorList;
  final double dragSpeed;
  final List<CircleBNBItem> items;
  final Function (int index) onChangeIndex;
  final NavigationStyle navigationStyle;
  final int? linearItemCount;

  const CircleBNB({
    super.key,
    required this.size,
    this.colorList,
    required this.dragSpeed,
    required this.items,
    required this.onChangeIndex,
    this.navigationStyle = NavigationStyle.linear,
    this.linearItemCount = 3
  }) : assert(items.length >= 3, 'items must contain more than 3 elements.'),
       assert(colorList == null || colorList.length == 4, 'colorList must be null or have more than 4 elements.'),
       assert(linearItemCount == null || (linearItemCount % 2 == 1 && linearItemCount <= 5 && linearItemCount <= items.length), 'linearItemCount must be an odd number, no more than 5 and not greater than the number of items.'),
       assert(linearItemCount == null || !(navigationStyle == NavigationStyle.linear && linearItemCount > items.length), 'linearItemCount cannot be greater than the number of items when using linear navigation style.');

  @override
  State<CircleBNB> createState() => _CircleBNBState();
}

class _CircleBNBState extends State<CircleBNB> {
  late final CircleBnbController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CircleBnbController(widget);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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