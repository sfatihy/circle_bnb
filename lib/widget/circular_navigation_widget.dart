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
            const SizedBox(height: 36),
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
        return Transform.rotate(
          angle: dataValue,
          child: child,
        );
      },
      child: Center(
        child: Container(
          width: controller.widget.size.width,
          height: controller.widget.size.width,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black26,
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

            return AnimatedAlign(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOutBack,
              alignment: (isTop && isDone)
                ? Alignment(controller.circleBNB.alignmentList[index].x * 1.3, controller.circleBNB.alignmentList[index].y * 1.3)
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
                      child: Align(
                        alignment: const Alignment(0, -0.75),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: isTop ? 4 : 0,
                          children: [
                            if (isTop)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    controller.widget.items[index].icon,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            RotatedBox(
                              quarterTurns: isTop ? 0 : 1,
                              child: SizedBox(
                                width: controller.widget.size.width * 0.3,
                                child: Text(
                                  controller.widget.items[index].title,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.center,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 36.0),
      child: Column(
        spacing: 8,
        children: [
          const Icon(
            Icons.arrow_upward,
            size: 12,
            color: Colors.white,
          ),
          GestureDetector(
            onTap: controller.onCenterTextTap,
            child: ValueListenableBuilder<int>(
              valueListenable: controller.topIndex,
              builder: (context, topIndex, child) {
                return Text(
                  controller.widget.items[topIndex].title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}