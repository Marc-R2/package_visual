import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_visual/animation/package.dart';

/// Animate a red box representing the timeout of the oldest package
class AnimatedTimeout extends StatefulWidget {
  /// Create a new AnimatedTimeout instance
  const AnimatedTimeout({
    super.key,
    required this.width,
    required this.height,
    required this.package,
  });

  /// width of the timeout box
  final double width;

  /// height of the timeout box
  final double height;

  /// The package to check for timeout
  final List<Package> package;

  @override
  State<AnimatedTimeout> createState() => _AnimatedTimeoutState();
}

class _AnimatedTimeoutState extends State<AnimatedTimeout> {
  double height = 0;
  Timer? updateTimer;

  @override
  void initState() {
    _update();
    updateTimer = Timer.periodic(const Duration(milliseconds: 256), _update);
    super.initState();
  }

  void _update([Timer? t]) {
    // Get the highest package.timeOutProgress value
    final progress = widget.package
        .map((item) => item.isTimedOut ? 0 : item.timeOutProgress)
        .reduce((value, element) => value > element ? value : element);

    height = widget.height * progress;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AnimatedContainer(
        height: height,
        width: widget.width,
        duration: const Duration(milliseconds: 256),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(4),
          color: Colors.red.shade500,
        ),
      ),
    );
  }
}
