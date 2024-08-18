import 'dart:math';

import 'package:flutter/material.dart';

class CircleBNBModel {

  late List<Alignment> _alignmentList;
  late final List<double> _angleListPi;
  late final List<double> _angleListPi2;

  CircleBNBModel () {
    _alignmentList = alignmentList_8;
    _angleListPi   = angleListPi_8;
    _angleListPi2  = angleListPi2_8;
  }

  /// stack içerisindeki item ların konumunu ayarlamak için kullanılıyor.
  List<Alignment> get alignmentList => _alignmentList;
  /// stack içerisindeki item lar için rotate sağlıyor.
  List<double> get angleListPi => _angleListPi;
  /// döndürme için gerekli sınırları sağlıyor.
  List<double> get angleListPi2 => _angleListPi2;

  List<Alignment> alignmentList_8 = [
    const Alignment(0, -1),
    Alignment(sqrt(2) / 2, -sqrt(2) / 2),
    const Alignment(1, 0),
    Alignment(sqrt(2) / 2, sqrt(2) / 2),
    const Alignment(0, 1),
    Alignment(-sqrt(2) / 2, sqrt(2) / 2),
    const Alignment(-1, 0),
    Alignment(-sqrt(2) / 2, -sqrt(2) / 2)
  ];

  final List<double> angleListPi_8 = [
    0,          // 0 - 0
    pi / 4,     // 7 - 0.7853981633974483
    pi / 2,     // 6 - 1.5707963267948966
    pi / 1.33,  // 5 - 2.362099739541198
    pi,         // 4 - 3.141592653589793
    -pi / 1.33, // 3 - -2.362099739541198
    -pi / 2,    // 2 - -1.5707963267948966
    -pi / 4     // 1 - -0.7853981633974483
  ];

  final List<double> angleListPi2_8 = [
    0,
    pi / 4,    //0.7853981633974483
    pi / 2,    //1.5707963267948966
    pi / 1.33, //2.362099739541198
    pi,        //3.141592653589793
    pi / 0.80, //3.9269908169872414
    pi / 0.70, //4.487989505128276
    pi / 0.60, //5.235987755982989
    pi / 0.53, //5.927533308659987
  ];

}
