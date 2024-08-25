import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:circle_bnb/clipper/circle_bnb_clipper.dart';
import 'package:circle_bnb/model/circle_bnb_model.dart';

class CircleBNB extends StatefulWidget {

  final Size size;
  final List<Color>? colorList;
  final double dragSpeed;
  final List<String> dataList;
  final Function (int index) onChangeIndex;

  const CircleBNB({
    super.key,
    required this.size,
    this.colorList,
    required this.dragSpeed,
    required this.dataList,
    required this.onChangeIndex
  }) : assert(colorList == null || colorList.length == 4, 'colorList must be null or have more than 4 elements.');

  @override
  State<CircleBNB> createState() => _CircleBNBState();
}

class _CircleBNBState extends State<CircleBNB> {

  CircleBNBModel? circleBNB;

  late List<double> angleListPi;
  late List<double> angleListPi2;
  late int topIndex;
  late List<Color> colorList;

  double data = 0.0;

  late DragStartDetails detailsVar;

  double aradaki_fark = 0.25;
  bool isDone = true;

  @override
  void initState() {
    super.initState();

    circleBNB = CircleBNBModel(widget.dataList.length);
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

        for (int i = 1; i <= widget.dataList.length; i++) {
          if ((angleListPi2[i] - aradaki_fark < data && data < angleListPi2[i]) || (-angleListPi2[widget.dataList.length-i] - aradaki_fark < data && data < -angleListPi2[widget.dataList.length-i])) {
            topIndex = widget.dataList.length-i;
            if(topIndex == 0) data = 0;
            //log("${data} -> ${topIndex}");
          }
          else if ((angleListPi2[widget.dataList.length] - aradaki_fark < data && data < angleListPi2[widget.dataList.length]) || (topIndex == 1 && angleListPi2[0] - aradaki_fark < data && data < angleListPi2[0])) {
            topIndex = 0;
            //log("${data} -> ${topIndex}");
            data = 0;
            //log("Data dönme değeri 0 landı.");
          }
          else {
            //log(data.toString());
          }
        }
        
      }
      // clockwise
      else {
        data = data - widget.dragSpeed;

        for (int i = 1; i <= widget.dataList.length-1; i++) {
          if ((angleListPi2[i] - aradaki_fark < data && data < angleListPi2[i]) || (-angleListPi2[widget.dataList.length-i] - aradaki_fark < data && data < -angleListPi2[widget.dataList.length-i])) {
            topIndex = widget.dataList.length-i;
            if(topIndex == 0) data = 0;
            //log("${data} -> ${topIndex}");
          }
          else if ((topIndex == widget.dataList.length-1 && angleListPi2[0] < data && data < angleListPi2[0] + aradaki_fark) || (-angleListPi2[widget.dataList.length] < data && data < -angleListPi2[widget.dataList.length] + aradaki_fark)) {
            topIndex = 0;
            //log("${data} -> ${topIndex}");
            data = 0;
            //log("Data dönme değeri 0 landı.");
          }
          else {
            //log(data.toString());
          }
        }
      }
    });
  }

  _clickState (clickedIndex) {

    //log("TopIndex: $topIndex");
    //log("Index: $clickedIndex");

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              onHorizontalDragStart: (details) {
                //log("**");
                //log(details.toString());
                //log("**");

                setState(() {
                  isDone = false;
                  detailsVar = details;
                });
              },
              onHorizontalDragUpdate: (details) {
                _cyclingMechanic(details);
              },
              onHorizontalDragEnd: ((details) {
                setState(() {
                  isDone = true;
                  //log("Drag End : ${angleListPi.length - topIndex}" );
                  data = angleListPi[angleListPi.length - topIndex > widget.dataList.length-1 ? 0 : angleListPi.length - topIndex];
                  //data = double.parse("${angleListPi.length - topIndex}");
                  widget.onChangeIndex(topIndex);
                });
              }),
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
                          children: List.generate(widget.dataList.length, (int index) {
                            // burdaki alingnment ile daire içerisindeki konumu belirleniyor
                            return AnimatedAlign(
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeInOutBack,
                              alignment: (index == topIndex && isDone == true)
                                ? Alignment(circleBNB!.alignmentList[index].x * 1.3, circleBNB!.alignmentList[index].y * 1.3)
                                : circleBNB!.alignmentList[index],
                              // burdaki angle clipper ın angle ı
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
                                          : ((topIndex == index + 1 || topIndex == index - 1) || (topIndex == 0 && index == 7) || (topIndex == 7 && index == 0))
                                          ? colorList[1]
                                          : ((topIndex == index + 2 || topIndex == index - 2) || (topIndex == 0 && index == 6) || (topIndex == 6 && index == 0) || (topIndex == 7 && index == 1) || (topIndex == 1 && index == 7))
                                          ? colorList[2]
                                          : colorList[3],
                                      ),
                                      child: Center(
                                        child: RotatedBox(
                                          quarterTurns: index == topIndex ? 0 : 1,
                                          child: SizedBox(
                                            width: widget.size.width * 0.25,
                                            child: Text(
                                              widget.dataList[index],
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
                            widget.dataList[topIndex],
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