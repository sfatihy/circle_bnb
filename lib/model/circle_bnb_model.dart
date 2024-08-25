import 'dart:math';

import 'package:flutter/material.dart';

class CircleBNBModel {

  late List<Alignment> _alignmentList;
  late List<double> _angleListPi;
  late List<double> _angleListPi2;

  CircleBNBModel (int itemCount) {
    _alignmentList = _generateAlignmentList(itemCount);
    _angleListPi   = _generateAngleListPi(itemCount);
    _angleListPi2  = _generateAngleListPi2(itemCount);
  }

  /*
  Alignment Positions:
  -1,-1       0,-1        1,-1

  -1,0        0,0         1,0

  -1,1        0,1         1,1
   */

  /// stack içerisindeki item ların konumunu ayarlamak için kullanılıyor.
  List<Alignment> get alignmentList => _alignmentList;
  /// stack içerisindeki item lar için rotate sağlıyor.
  List<double> get angleListPi => _angleListPi;
  /// döndürme için gerekli sınırları sağlıyor.
  List<double> get angleListPi2 => _angleListPi2;

  List<Alignment> _generateAlignmentList(int itemCount) {
    List<Alignment> alignments = [];

    for (int i = 0; i < itemCount; i++) {
      double angle = (i * 2 * pi / itemCount) - (pi / 2);
      alignments.add(Alignment(cos(angle), sin(angle)));
    }

    return alignments;
  }

  List<double> _generateAngleListPi(int count) {
    List<double> angleListPi = [];
    for (int i = 0; i < count; i++) {
      if (i <= count / 2) {
        angleListPi.add(i * pi / (count / 2));
      }
      else {
        angleListPi.add(-((count - i) * pi / (count / 2)));
      }
    }
    return angleListPi;
  }

  List<double> _generateAngleListPi2(int count) {
    List<double> angleListPi2 = [];
    double step = 2 * pi / count;

    for (int i = 0; i <= count; i++) {
      angleListPi2.add(i * step);
    }

    return angleListPi2;
  }

}
