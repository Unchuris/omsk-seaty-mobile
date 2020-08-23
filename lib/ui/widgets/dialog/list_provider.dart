import 'package:flutter/material.dart';

class ListProvider extends InheritedWidget {
  final Map<Object, bool> list;
  final Widget child;

  ListProvider(this.list, this.child);

  @override
  bool updateShouldNotify(ListProvider oldWidget) => oldWidget.list != list;

  static ListProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();
}
