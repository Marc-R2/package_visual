import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_visual/animation/animated_package_in_column.dart';
import 'package:package_visual/animation/package.dart';
import 'package:package_visual/settings/settings_controller.dart';

class PackageColumn extends StatelessWidget {
  const PackageColumn({
    super.key,
    required this.index,
    required this.width,
    required this.height,
    required this.package,
    required this.maxHeight,
  });

  /// The index of the column
  final int index;

  /// Width of a Item (and the Column)
  final double width;

  /// Height of a Item
  final double height;

  /// The height of the column
  final double maxHeight;

  /// The Package to display
  final Package? package;

  int get _currentSendFrame => Settings.currentSendFrame;

  int get _currentReceiveFrame => Settings.currentReceiveFrame;

  bool? _isReceived(DateTime? time) {
    if (time == null) return null;
    return DateTime.now().isAfter(time);
  }

  @override
  Widget build(BuildContext context) {
    final isReceived =
        _isReceived(package?.receiveTime) ?? index < _currentReceiveFrame;
    final isConfirmed =
        _isReceived(package?.confirmationTime) ?? index < _currentSendFrame;

    final column = Padding(
      padding: const EdgeInsets.all(8),
      child: DecoratedBox(
        key: ValueKey(index),
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.25)),
        child: Column(
          children: [
            // Sending Rectangle on top
            SizedBox(
              width: width,
              height: height,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 512),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4),
                  color: isConfirmed ? Colors.yellow : Colors.blue,
                ),
              ),
            ),
            // Space between the two Rectangles
            const Spacer(),
            // Receiving Rectangle on bottom
            SizedBox(
              width: width,
              height: height,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 256),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4),
                  color: isReceived ? Colors.deepPurple.shade900 : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (package == null) return column;
    return Stack(
      children: [
        AnimatedPackageInColumn(
          height: height,
          maxHeight: maxHeight,
          width: width,
          package: package!,
        ),
        column,
        AnimatedTimeout(
          height: height,
          width: width,
          package: package!,
        ),
      ],
    );
  }
}

class AnimatedTimeout extends StatefulWidget {
  const AnimatedTimeout({
    super.key,
    required this.width,
    required this.height,
    required this.package,
  });

  final double width;
  final double height;
  final Package package;

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
    height = widget.height * widget.package.timeOutProgress;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AnimatedOpacity(
        opacity: widget.package.timeOutProgress > 0.92 ? 0 : 1,
        duration: const Duration(milliseconds: 256),
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
      ),
    );
  }
}
