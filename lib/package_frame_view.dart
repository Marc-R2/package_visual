import 'dart:math';

import 'package:flutter/material.dart';
import 'package:package_visual/animation/animated_package_in_column.dart';
import 'package:package_visual/animation/package.dart';
import 'package:package_visual/settings/settings_controller.dart';
import 'package:package_visual/util/scroll_behavior.dart';

class PackageFrameView extends StatelessWidget {
  const PackageFrameView({super.key, required this.items});

  final Map<int, Package> items;

  int get _currentSendFrame => Settings.currentSendFrame;

  int get _currentReceiveFrame => Settings.currentReceiveFrame;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        final height = cons.maxHeight / 12;
        final width = height / 2;
        return ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: max(_currentSendFrame, _currentReceiveFrame) + 48,
            itemBuilder: (context, index) => PackageColumn(
              index: index,
              height: height,
              width: width,
              maxHeight: cons.maxHeight,
              package: items[index],
            ),
          ),
        );
      },
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    final isReceived = package?.isReceived ?? index < _currentReceiveFrame;
    final isConfirmed = package?.isConfirmed ?? index < _currentSendFrame;

    final column = Padding(
      padding: const EdgeInsets.all(8),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.25)),
        child: Column(
          children: [
            // Sending Rectangle on top
            SizedBox(
              width: width,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(),
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(),
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
        column,
        AnimatedPackageInColumn(
          height: height,
          maxHeight: maxHeight,
          width: width,
          package: package!,
        ),
      ],
    );
  }
}
