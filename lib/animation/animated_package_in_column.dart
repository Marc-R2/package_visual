import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_visual/animation/package.dart';
import 'package:package_visual/settings/settings_controller.dart';

class AnimatedPackageInColumn extends StatefulWidget {
  const AnimatedPackageInColumn({
    super.key,
    required this.package,
    required this.width,
    required this.height,
    required this.maxHeight,
  });

  /// The Package to display
  final Package package;

  /// Width of a Item (and the Column)
  final double width;

  /// Height of a Item
  final double height;

  /// The height of the column
  final double maxHeight;

  @override
  State<AnimatedPackageInColumn> createState() =>
      _AnimatedPackageInColumnState();
}

class _AnimatedPackageInColumnState extends State<AnimatedPackageInColumn> {
  Timer? _timer;

  bool isDone = false;

  int get index => widget.package.index;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 32), _update);
    super.initState();
  }

  void _update([Timer? t]) {
    if (widget.package.isDone && !widget.package.isDestroyed) {
      _timer?.cancel();
      Settings.packages[index] = widget.package.copyWith(isConfirmed: true);
      isDone = true;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pos = widget.package.packagePosition *
        (widget.maxHeight - widget.height - 16);

    if (isDone) return const SizedBox();

    return Positioned(
      top: 8 + pos,
      left: 8,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(),
          color: widget.package.isReceived ? Colors.orange : Colors.red,
        ),
      ),
    );
  }
}
