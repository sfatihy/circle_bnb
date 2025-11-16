import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../clippers/circle_bnb_clipper.dart';
import '../controller/circle_bnb_controller.dart';

class CircularNavigationWidget extends StatelessWidget {
  final CircleBnbController controller;

  const CircularNavigationWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: controller.widget.size.height,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 32),
            GestureDetector(
              dragStartBehavior: DragStartBehavior.start,
              onHorizontalDragStart: controller.onDragStart,
              onHorizontalDragUpdate: controller.cyclingMechanic,
              onHorizontalDragEnd: controller.onDragEnd,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _RotatingWheel(controller: controller),
                  _CenterContent(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RotatingWheel extends StatelessWidget {
  final CircleBnbController controller;

  const _RotatingWheel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: controller.data,
      builder: (context, dataValue, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: controller.isDone,
          builder: (context, isDone, _) {
            return AnimatedRotation(
              turns: dataValue / (2 * pi),
              duration: isDone ? const Duration(milliseconds: 700) : Duration.zero,
              curve: Curves.easeInOut,
              child: child,
            );
          },
        );
      },
      child: Center(
        child: Container(
          width: controller.widget.size.width,
          height: controller.widget.size.width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: controller.widget.circularBackgroundColor ?? Colors.black26,
          ),
          child: Stack(
            children: List.generate(controller.widget.items.length, (int index) {
              return _CircleItem(controller: controller, index: index);
            }),
          ),
        ),
      ),
    );
  }
}

class _CircleItem extends StatelessWidget {
  final CircleBnbController controller;
  final int index;

  const _CircleItem({required this.controller, required this.index});

  Color _getItemColor(
    int topIndex,
    int currentIndex,
    int itemCount,
    List<Color> colorList
  ) {
    final diff = (currentIndex - topIndex).abs();
    final wrappedDiff = min(diff, itemCount - diff);

    switch (wrappedDiff) {
      case 0:
        return colorList[0];
      case 1:
        return colorList[1];
      case 2:
        return colorList[2];
      default:
        return colorList[3];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller.topIndex,
      builder: (context, topIndex, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: controller.isDone,
          builder: (context, isDone, _) {
            final isTop = index == topIndex;

            final itemCount = controller.widget.items.length;
            int offset = index - topIndex;
            if (offset > itemCount / 2) {
              offset -= itemCount;
            } else if (offset < -itemCount / 2) {
              offset += itemCount;
            }

            int quarterTurns;
            if (isTop) {
              quarterTurns = 0;
            } else if (offset > 0) {
              // Left side
              quarterTurns = -1;
            } else {
              // Right side (and bottom)
              quarterTurns = 1;
            }

            return OverflowBox(
              maxWidth: controller.widget.size.width * ((isDone && isTop) ? 1.15 : 1),
              maxHeight: controller.widget.size.width * ((isDone && isTop) ? 1.15 : 1),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                alignment: (isDone && isTop)
                  ? Alignment(controller.circleBNB.alignmentList[index].x * 1.15, controller.circleBNB.alignmentList[index].y * 1.15)
                  : controller.circleBNB.alignmentList[index],
                child: Transform.rotate(
                  angle: controller.angleListPi[index],
                  child: GestureDetector(
                    onTap: () => controller.clickState(index),
                    child: ClipPath(
                      clipper: CircleBottomNavigationBarClipper(itemCount: controller.widget.items.length),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: controller.widget.size.width,
                        width: controller.widget.size.width,
                        decoration: BoxDecoration(
                          color: _getItemColor(topIndex, index, controller.widget.items.length, controller.colorList),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ((isTop && controller.widget.showTextWhenSelected) || (!isTop && controller.widget.showTextWhenUnselected)) ? 8.0 : 32.0
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if ((isTop && controller.widget.showIconWhenSelected) || (!isTop && controller.widget.showIconWhenUnselected))
                                Icon(
                                  controller.widget.items[index].icon,
                                  size: 24,
                                  color: controller.widget.items[index].iconColor ?? (isTop ? controller.widget.selectedIconColor : controller.widget.unselectedIconColor) ?? Colors.black,
                                ),
                              if ((isTop && controller.widget.showTextWhenSelected) || (!isTop && controller.widget.showTextWhenUnselected))
                                Padding(
                                  padding: EdgeInsets.only(top: isTop ? 4.0 : (controller.widget.showIconWhenUnselected ? 8.0 : 0.0)),
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(end: quarterTurns * pi / 2),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    builder: (context, angle, child) {
                                      return Transform.rotate(
                                        angle: angle,
                                        child: child,
                                      );
                                    },
                                    child: SizedBox(
                                      width: controller.widget.size.width * 0.275 - (isTop ? 24 : 16),
                                      height: controller.widget.size.width * 0.275 - 16,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          controller.widget.items[index].title,
                                          style: controller.widget.items[index].textStyle ?? (isTop ? controller.widget.selectedTextStyle : controller.widget.unselectedTextStyle) ?? Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CenterContent extends StatelessWidget {
  final CircleBnbController controller;

  const _CenterContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: controller.onCenterTextTap,
      icon: const Icon(
        Icons.arrow_upward,
        size: 24,
      ),
    );
  }
}