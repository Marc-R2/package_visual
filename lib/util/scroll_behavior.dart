import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A [ScrollBehavior] that does allow to drag the scrollable area with a mouse,
/// touch or pen/stylus.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  };
}
