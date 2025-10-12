import 'package:flutter/material.dart';

import '../state/index_notifier.dart';

// An InheritedWidget to provide the IndexNotifier down the widget tree.
class IndexProvider extends InheritedWidget {
  final IndexNotifier indexNotifier;

  const IndexProvider({
    super.key,
    required this.indexNotifier,
    required super.child,
  });

  static IndexNotifier of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<IndexProvider>()!.indexNotifier;
  }

  @override
  bool updateShouldNotify(IndexProvider oldWidget) {
    // This will be false since we'll provide the same notifier instance.
    return indexNotifier != oldWidget.indexNotifier;
  }
}