import 'package:flutter/material.dart';

// https://diamantidis.github.io/2020/07/07/dart-extensions-flatten-flutter-nested-widget-trees

extension WidgetModifier on Widget {
  Widget padding([EdgeInsetsGeometry value = const EdgeInsets.all(16)]) {
    return Padding(
      padding: value,
      child: this,
    );
  }

  Widget center() {
    return Center(
      child: this,
    );
  }

    Widget expanded() {
    return Expanded(
      child: this,
    );
  }
}
