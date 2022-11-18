import 'package:flutter/material.dart';

class OpenMenuItem<T> {
  const OpenMenuItem({
    required this.leading,
    required this.editable,
    this.height = 48,
  });

  final Widget leading;
  final Widget editable;
  final double height;
}
