import 'package:flutter/material.dart';

// A ValueNotifier to hold the state (the current index).
class IndexNotifier extends ValueNotifier<int> {
  IndexNotifier() : super(0);

  set index(int newIndex) {
    value = newIndex;
  }

  int get index => value;
}