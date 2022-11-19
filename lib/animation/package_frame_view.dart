import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:package_visual/animation/package.dart';
import 'package:package_visual/animation/package_column.dart';
import 'package:package_visual/settings/protocol.dart';
import 'package:package_visual/settings/settings_controller.dart';
import 'package:package_visual/util/animated_positioned_with_static.dart';
import 'package:package_visual/util/scroll_behavior.dart';

/// A widget for the animation area
class PackageFrameView extends StatefulWidget {
  /// Create a new PackageFrameView instance
  const PackageFrameView({
    super.key,
    required this.scrollController,
  });

  /// The ScrollController for the ListView in the animated area
  final ScrollController scrollController;

  /// Update the timer for the animation
  /// to match the sendInterval
  static void Function() get setTimer => _PackageFrameViewState.setTimer;

  @override
  State<PackageFrameView> createState() => _PackageFrameViewState();
}

class _PackageFrameViewState extends State<PackageFrameView> {
  static int get _currentSendFrame => Settings.currentSendFrame;

  static int get _currentReceiveFrame => Settings.currentReceiveFrame;

  double _xScroll = 0;
  double _width = 1;

  static Timer? updateTimer;
  Timer? updateTimerPos;

  @override
  void initState() {
    setTimer();
    widget.scrollController.addListener(updateScroll);
    updateTimerPos = Timer.periodic(
      const Duration(milliseconds: 64),
      updatePositions,
    );
    super.initState();
  }

  static void setTimer() {
    updateTimer?.cancel();
    updateTimer = Timer.periodic(
      Duration(milliseconds: Settings.sendInterval),
      update,
    );
  }

  void updateScroll() {
    if (mounted) setState(() => _xScroll = widget.scrollController.offset);
  }

  void updatePositions([Timer? t]) {
    // Move the slider for the received packages
    final receiveFrames = Settings.packages
        .where((element) => element.index == _currentReceiveFrame);
    if (receiveFrames.any((item) => item.isReceived && !item.isDestroyed)) {
      Settings.currentReceiveFrame++;
    }

    // Move the slider for the confirmed packages
    final sendFrames =
        Settings.packages.where((item) => item.index == _currentSendFrame);

    final finishedSendFrames =
        sendFrames.where((item) => item.isConfirmed && !item.isDestroyed);

    if (finishedSendFrames.isNotEmpty) {
      Settings.currentSendFrame++;
      autoUpdateScroll();
    }

    Settings.packages.removeWhere(
      (item) => item.isConfirmed && item.index < _currentSendFrame,
    );

    setState(() {});
  }

  static void update([Timer? t]) {
    final size = Settings.windowSize;
    if (!Settings.doSendPackages) return;

    for (var i = 0; i < size; i++) {
      final index = _currentSendFrame + i;
      final frames = Settings.packages.where((item) => item.index == index);

      if (frames.isEmpty) {
        Settings.packages.add(Package.fromSettings(index: index));
        break;
      }

      // Get the oldest frame
      final oldestFrame = frames.reduce((value, element) {
        if (value.receiveTime.isBefore(element.receiveTime)) return value;
        return element;
      });

      if (oldestFrame.protocol == Protocol.selectiveRepeat) {
        if (frames.any((item) => item.isTimedOut)) {
          if (!frames.any((item) => !item.isDestroyed && item.isConfirmed)) {
            if (!frames.any((item) => !item.isTimedOut)) {
              Settings.packages.add(Package.fromSettings(index: index));
              break;
            }
          }
        }
      } else if (oldestFrame.protocol == Protocol.goBackN) {
        // TODO(any): Implement
      }
    }
  }

  void autoUpdateScroll() {
    final newPos = _currentSendFrame * (_width + 16);
    final scrollPos = widget.scrollController.offset;

    // if new position is in range of a few _widths, scroll to it
    if (newPos - scrollPos < _width * 12) {
      widget.scrollController.animateTo(
        newPos,
        duration: const Duration(milliseconds: 256),
        curve: Curves.easeInOut,
      );
    }

  }

  List<Package> getItems(int index) =>
      Settings.packages.where((item) => item.index == index).toList();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        final height = cons.maxHeight / 12;
        final width = height / 2;
        _width = width;
        return Stack(
          children: [
            AnimatedStaticPositioned(
              duration: Duration(milliseconds: min(256, Settings.sendInterval)),
              staticLeft: _xScroll * -1,
              animatedLeft: (width + 16) * Settings.currentSendFrame + 16,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 256),
                width: (width + 16) * Settings.windowSize,
                height: height + 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            AnimatedStaticPositioned(
              duration: Duration(milliseconds: min(256, Settings.sendInterval)),
              staticBottom: 0,
              staticLeft: _xScroll * -1,
              animatedLeft: (width + 16) * Settings.currentReceiveFrame + 16,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 256),
                width: (width + 16) * Settings.windowSize,
                height: height + 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView.builder(
                controller: widget.scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: max(_currentSendFrame, _currentReceiveFrame) + 48,
                itemBuilder: (context, index) => PackageColumn(
                  key: ValueKey('PackageColumn: $index'),
                  index: index,
                  height: height,
                  width: width,
                  maxHeight: cons.maxHeight,
                  package: getItems(index),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
