import 'package:flutter/material.dart';
import 'package:package_visual/animation/animated_package_in_column.dart';
import 'package:package_visual/animation/animated_timeout.dart';
import 'package:package_visual/animation/package.dart';
import 'package:package_visual/settings/settings_controller.dart';

/// A widget that displays a Column for a Package
class PackageColumn extends StatelessWidget {
  /// Create a new PackageColumn instance
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
  final List<Package> package;

  int get _currentSendFrame => Settings.currentSendFrame;

  int get _currentReceiveFrame => Settings.currentReceiveFrame;

  @override
  Widget build(BuildContext context) {
    final isReceived = package.isEmpty
        ? index < _currentReceiveFrame
        : package.any((item) => item.isReceived) ||
            index < _currentReceiveFrame;

    final isConfirmed = package.isEmpty
        ? index < _currentSendFrame
        : package.any((item) => item.isConfirmed) || index < _currentSendFrame;

    final column = Padding(
      padding: const EdgeInsets.all(8),
      child: IgnorePointer(
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
                    color:
                        isReceived ? Colors.deepPurple.shade900 : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (package.isEmpty) return column;
    return Stack(
      children: [
        for (final item in package)
          AnimatedPackageInColumn(
            key: ValueKey(item),
            package: item,
            width: width,
            height: height,
            maxHeight: maxHeight,
          ),
        column,
        AnimatedTimeout(
          height: height,
          width: width,
          package: package,
        ),
      ],
    );
  }
}
