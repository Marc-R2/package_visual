import 'package:flutter/material.dart';

class OpenMenuItem {
  const OpenMenuItem({
    required this.leading,
    required this.editable,
    this.height = 48,
    this.onTap,
  });

  final Widget leading;
  final Widget editable;
  final double height;
  final void Function()? onTap;
}
