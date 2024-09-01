import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:circle_bnb/clippers/circle_bnb_clipper.dart';
import 'package:circle_bnb/enums/navigation_style.dart';
import 'package:circle_bnb/models/circle_bnb_item_model.dart';
import 'package:circle_bnb/models/circle_bnb_model.dart';

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

  CircleBNBModel? circleBNB;

  late List<double> angleListPi;
  late List<double> angleListPi2;
  late int topIndex;
  late List<Color> colorList;
  late bool isLinearLayout;

  double data = 0.0;

  late DragStartDetails detailsVar;

  double difference = 0.25;
  bool isDone = true;

  @override
  void initState() {
    super.initState();

    circleBNB = CircleBNBModel(widget.items.length);
    topIndex = 0;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    angleListPi = circleBNB!.angleListPi;
    angleListPi2 = circleBNB!.angleListPi2;

    colorList = widget.colorList ?? [
      Colors.cyan.shade100,
      Colors.blue,
      Colors.green.shade200,
      Colors.purpleAccent
    ];

    isLinearLayout = widget.navigationStyle == NavigationStyle.linear;
  }

  @override
  void dispose() {
    super.dispose();
  }


  _cyclingMechanic(DragUpdateDetails details) {
    setState(() {
      // counter clockwise
      if (details.localPosition.dx.floorToDouble() > detailsVar.localPosition.dx.floorToDouble()) {
        data = data + widget.dragSpeed;

        for (int i = 1; i <= widget.items.length; i++) {
          if ((angleListPi2[i] - difference < data && data < angleListPi2[i]) || (-angleListPi2[widget.items.length-i] - difference < data && data < -angleListPi2[widget.items.length-i])) {
            topIndex = widget.items.length-i;
            if(topIndex == 0) data = 0;
          }
          else if ((angleListPi2[widget.items.length] - difference < data && data < angleListPi2[widget.items.length]) || (topIndex == 1 && angleListPi2[0] - difference < data && data < angleListPi2[0])) {
            topIndex = 0;
            data = 0;
          }
          else {
          }
        }
      }
      // clockwise
      else {
        data = data - widget.dragSpeed;

        for (int i = 1; i <= widget.items.length-1; i++) {
          if ((angleListPi2[i] - difference < data && data < angleListPi2[i]) || (-angleListPi2[widget.items.length-i] - difference < data && data < -angleListPi2[widget.items.length-i])) {
            topIndex = widget.items.length-i;
            if(topIndex == 0) data = 0;
          }
          else if ((topIndex == widget.items.length-1 && angleListPi2[0] < data && data < angleListPi2[0] + difference) || (-angleListPi2[widget.items.length] < data && data < -angleListPi2[widget.items.length] + difference)) {
            topIndex = 0;
            data = 0;
          }
          else {

          }
        }
      }
    });
  }

  _clickState (clickedIndex) {

    setState(() {

      if (clickedIndex == 0) {
        data = 0.0;
      }
      else {
        for (int i = 0; i < angleListPi.length; i++) {
          if (clickedIndex == i) {
            data = angleListPi[angleListPi.length-i];
            break;
          }
        }
      }

      topIndex = clickedIndex;

      widget.onChangeIndex(topIndex);

      if(widget.navigationStyle == NavigationStyle.linear) {
        isLinearLayout = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLinearLayout ?
    BottomNavigationBar(
      currentIndex: (widget.linearItemCount! - 1) ~/ 2,
      items: List.generate(widget.linearItemCount!, (index) {
        int itemIndex = (topIndex + index - (widget.linearItemCount! - 1) ~/ 2) % widget.items.length;
        return BottomNavigationBarItem(
          label: widget.items[itemIndex].title,
          icon: Icon(
            itemIndex == topIndex ? Icons.arrow_upward : widget.items[itemIndex].icon,
          ),
        );
      }),
      onTap: (value) {
        if (value == (widget.linearItemCount! - 1) ~/ 2) {
          setState(() {
            isLinearLayout = false;
          });
        }
        else {
          setState(() {
            _clickState((topIndex + value - (widget.linearItemCount! - 1) ~/ 2) % widget.items.length);
          });
        }
      },
    )
    : SizedBox(
      height: widget.size.height,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 36,
            ),
            GestureDetector(
              dragStartBehavior: DragStartBehavior.start,
              onHorizontalDragStart: (DragStartDetails details) {
                setState(() {
                  isDone = false;
                  detailsVar = details;
                });
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                _cyclingMechanic(details);
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                setState(() {
                  isDone = true;
                  data = angleListPi[angleListPi.length - topIndex > widget.items.length-1 ? 0 : angleListPi.length - topIndex];
                  widget.onChangeIndex(topIndex);

                  if(widget.navigationStyle == NavigationStyle.linear) {
                    isLinearLayout = true;
                  }
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: data,
                    child: Center(
                      child: Container(
                        width: widget.size.width,
                        height: widget.size.width,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black26
                        ),
                        child: Stack(
                          children: List.generate(widget.items.length, (int index) {
                            // buradaki alignment ile daire içerisindeki konumu belirleniyor.
                            return AnimatedAlign(
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeInOutBack,
                              alignment: (index == topIndex && isDone == true)
                                ? Alignment(circleBNB!.alignmentList[index].x * 1.3, circleBNB!.alignmentList[index].y * 1.3)
                                : circleBNB!.alignmentList[index],
                              // buradaki angle clipper ın angle ı
                              child: Transform.rotate(
                                angle: angleListPi[index],
                                child: GestureDetector(
                                  child: ClipPath(
                                    clipper: CircleBottomNavigationBarClipper(),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 500),
                                      height: widget.size.width / 2.5,
                                      width: widget.size.width / 2.5,
                                      decoration: BoxDecoration(
                                        color: topIndex == index
                                          ? colorList[0]
                                          : ((topIndex == index + 1 || topIndex == index - 1) || (topIndex == 0 && index == widget.items.length - 1) || (topIndex == widget.items.length - 1 && index == 0))
                                          ? colorList[1]
                                          : ((topIndex == index + 2 || topIndex == index - 2) || (topIndex == 0 && index == widget.items.length - 2) || (topIndex == widget.items.length - 2 && index == 0) || (topIndex == widget.items.length - 1 && index == 1) || (topIndex == 1 && index == widget.items.length - 1))
                                          ? colorList[2]
                                          : colorList[3],
                                      ),
                                      child: Align(
                                        alignment: const Alignment(0, -0.75),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            topIndex == index ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  widget.items[index].icon,
                                                  size: 18,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                              ],
                                            ) : const SizedBox(),
                                            RotatedBox(
                                              quarterTurns: index == topIndex ? 0 : 1,
                                              child: SizedBox(
                                                width: widget.size.width * 0.3,
                                                child: Text(
                                                  widget.items[index].title,
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
                                  onTap: () {
                                    _clickState(index);
                                  },
                                ),
                              ),
                            );
                          })
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 36.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          child: Text(
                            widget.items[topIndex].title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              data = angleListPi[0];
                              topIndex = 0;
                              widget.onChangeIndex(topIndex);

                              if(widget.navigationStyle == NavigationStyle.linear) {
                                isLinearLayout = true;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}