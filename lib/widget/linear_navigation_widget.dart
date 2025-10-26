import 'package:flutter/material.dart';

import '../controller/circle_bnb_controller.dart';

class LinearNavigationWidget extends StatelessWidget {
  final CircleBnbController controller;

  const LinearNavigationWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller.topIndex,
      builder: (context, topIndex, child) {
        return BottomNavigationBar(
          currentIndex: (controller.widget.linearItemCount! - 1) ~/ 2,
          items: List.generate(controller.widget.linearItemCount!, (index) {
            int itemIndex = (topIndex + index - (controller.widget.linearItemCount! - 1) ~/ 2) % controller.widget.items.length;
            return BottomNavigationBarItem(
              label: ((itemIndex == topIndex && controller.widget.showTextWhenSelected) || (itemIndex != topIndex && controller.widget.showTextWhenUnselected))
                ? controller.widget.items[itemIndex].title
                : '',
              icon: ((itemIndex == topIndex && controller.widget.showIconWhenSelected) || (itemIndex != topIndex && controller.widget.showIconWhenUnselected))
                ? Icon(
                    itemIndex == topIndex
                      ? Icons.arrow_upward
                      : controller.widget.items[itemIndex].icon,
                    size: (itemIndex != topIndex && !controller.widget.showTextWhenUnselected) ? 30.0 : null,
                  )
                : const SizedBox.shrink(),
            );
          }),
          onTap: (value) {
            if (value == (controller.widget.linearItemCount! - 1) ~/ 2) {
              controller.isLinearLayout.value = false;
            } else {
              controller.clickState((topIndex + value - (controller.widget.linearItemCount! - 1) ~/ 2) % controller.widget.items.length);
            }
          },
        );
      },
    );
  }
}