import 'dart:math';

import 'package:flutter/material.dart';
import 'package:package_visual/animation/animated_package_in_column.dart';
import 'package:package_visual/animation/package.dart';
import 'package:package_visual/animation/package_column.dart';
import 'package:package_visual/settings/settings_controller.dart';
import 'package:package_visual/util/animated_positioned_with_static.dart';
import 'package:package_visual/util/scroll_behavior.dart';

class PackageFrameView extends StatefulWidget {
  const PackageFrameView({
    super.key,
    required this.items,
    required this.scrollController,
  });

  final Map<int, Package> items;

  final ScrollController scrollController;

  @override
  State<PackageFrameView> createState() => _PackageFrameViewState();
}

class _PackageFrameViewState extends State<PackageFrameView> {
  int get _currentSendFrame => Settings.currentSendFrame;

  int get _currentReceiveFrame => Settings.currentReceiveFrame;

  double _xScroll = 0;

  @override
  void initState() {
    widget.scrollController.addListener(update);
    super.initState();
  }

  void update() {
    if (mounted) setState(() => _xScroll = widget.scrollController.offset);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        final height = cons.maxHeight / 12;
        final width = height / 2;
        return Stack(
          children: [
            AnimatedStaticPositioned(
              duration: const Duration(milliseconds: 256),
              staticLeft: _xScroll * -1,
              animatedLeft: (width + 16) * Settings.currentSendFrame + 16,
              child: Container(
                width: (width + 16) * Settings.windowSize,
                height: height + 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            AnimatedStaticPositioned(
              duration: const Duration(milliseconds: 256),
              staticBottom: 0,
              staticLeft: _xScroll * -1,
              animatedLeft: (width + 16) * Settings.currentReceiveFrame + 16,
              child: Container(
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
                  package: widget.items[index],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
