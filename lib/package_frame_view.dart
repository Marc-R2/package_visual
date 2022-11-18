import 'dart:math';

import 'package:flutter/material.dart';
import 'package:package_visual/util/scroll_behavior.dart';

class PackageFrameView extends StatelessWidget {
  const PackageFrameView({
    super.key,
    required this.currentSendFrame,
    required this.currentReceiveFrame,
    required this.frameSize,
    required int counter,
  }) : _counter = counter;

  final int currentSendFrame;
  final int currentReceiveFrame;
  final int frameSize;
  final int _counter;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        return ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: max(currentSendFrame, currentReceiveFrame) + 32,
            itemBuilder: (context, index) {
              final height = cons.maxHeight / 12;
              final width = height / 2;
              final isFirstInSendFrame = index == currentSendFrame;
              final isLastInSendFrame =
                  index == currentSendFrame + frameSize - 1;
              final isFirstInReceiveFrame = index == currentReceiveFrame;
              final isLastInReceiveFrame =
                  index == currentReceiveFrame + frameSize - 1;
              final isBeforeSendFrame = index + 1 > currentSendFrame;
              final isBeforeReceiveFrame = index + 1 > currentReceiveFrame;
              return Stack(
                children: [
                  // Gray background for the frame of the current send
                  // On the top row
                  if (index > currentSendFrame - 1 &&
                      index < currentSendFrame + frameSize)
                    Container(
                      height: height + 8,
                      width: width +
                          (isFirstInSendFrame || isLastInSendFrame ? 12 : 16),
                      margin: EdgeInsets.only(
                        top: 4,
                        left: isFirstInSendFrame ? 4 : 0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0, color: Colors.grey),
                        color: Colors.grey,
                      ),
                    ),
                  // Gray background for the frame of the current receive
                  // On the bottom row
                  if (index > currentReceiveFrame - 1 &&
                      index < currentReceiveFrame + frameSize)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: height + 8,
                        width: width +
                            (isFirstInReceiveFrame || isLastInReceiveFrame
                                ? 12
                                : 16),
                        margin: EdgeInsets.only(
                          bottom: 4,
                          left: isFirstInReceiveFrame ? 4 : 0,
                        ),
                        decoration: BoxDecoration(
                          // This Border is necessary,
                          // otherwise there are render-gaps between the Columns
                          // (other solutions are welcome)
                          border: Border.all(width: 0, color: Colors.grey),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  Container(
                    width: width,
                    height: cons.maxHeight,
                    margin: const EdgeInsets.all(8),
                    color: Colors.grey.withOpacity(0.25),
                  ),
                  // Animated Rectangle Package between Sender and Receiver
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    top: _counter * height,
                    child: Container(
                      width: width,
                      height: height,
                      margin: const EdgeInsets.all(8),
                      color: Colors.blue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SizedBox(
                          width: width,
                          height: height,
                          // Sending Rectangle on top
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: isBeforeSendFrame
                                  ? Colors.blue
                                  : Colors.yellow,
                            ),
                            child: Center(child: Text('$index')),
                          ),
                        ),
                        const Spacer(),
                        // Receiving Rectangle on bottom
                        SizedBox(
                          width: width,
                          height: height,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: isBeforeReceiveFrame
                                  ? Colors.white
                                  : Colors.deepPurple.shade900,
                            ),
                            child: Center(child: Text('$index')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
