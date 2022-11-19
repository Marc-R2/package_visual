import 'package:flutter/material.dart';

/// a item in an OpenMenu
class OpenMenuItem {
  /// Create a new OpenMenuItem instance
  const OpenMenuItem({
    required this.leading,
    required this.editable,
    this.height = 48,
    this.onTap,
  });

  /// The leading widget
  final Widget leading;

  /// The height of the item
  final double height;

  /// The hidden widget
  final Widget editable;

  /// The onTap callback
  final void Function()? onTap;
}
