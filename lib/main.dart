import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Package Visual',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static int currentSendFrame = 4;
  static int currentReceiveFrame = 6;
  static int frameSize = 5;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(builder: (context, cons) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final height = cons.maxHeight / 12;
            final width = height / 2;
            final isFirstInSendFrame = index == currentSendFrame;
            final isLastInSendFrame = index == currentSendFrame + frameSize - 1;
            final isFirstInReceiveFrame = index == currentReceiveFrame;
            final isLastInReceiveFrame = index == currentReceiveFrame + frameSize - 1;
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
                    width: width + (isFirstInSendFrame || isLastInSendFrame ? 12 : 16),
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
                      width: width + (isFirstInReceiveFrame || isLastInReceiveFrame ? 12 : 16),
                      margin: EdgeInsets.only(
                        bottom: 4,
                        left: isFirstInReceiveFrame ? 4 : 0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0, color: Colors.grey),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                Container(
                  width: width,
                  height: cons.maxHeight,
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.grey.withOpacity(0.25),
                ),
                // Animated Rectangle Package between Sender and Receiver
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  top: _counter * height,
                  child: Container(
                    width: width,
                    height: height,
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.blue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: width,
                        height: height,
                        // Sending Rectangle on top
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
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
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            color: isBeforeReceiveFrame
                                ? Colors.white
                                // A Dark Blue Rectangle
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
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
