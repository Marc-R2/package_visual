import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_visual/animation/package_frame_view.dart';
import 'package:package_visual/openMenu/open_menu_item.dart';
import 'package:package_visual/openMenu/open_menu_widget.dart';
import 'package:package_visual/settings/settings_controller.dart';

void main() {
  runApp(const MyApp());
}

/// The main app widget
class MyApp extends StatelessWidget {
  /// Create a new MyApp instance
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Package Visual',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

/// The main page of the app
class MyHomePage extends StatefulWidget {
  /// Create a new MyHomePage instance
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showSettings = false;

  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  void toggleSettings() => setState(() => showSettings = !showSettings);

  Future<void> reset() async {
    await scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 512),
      curve: Curves.easeInOutCirc,
    );
    Settings.reset();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selective Repeat / Go Back N'),
      ),
      body: Row(
        children: [
          OpenMenu(
            items: [
              // Headline
              OpenMenuItem(
                leading: IconButton(
                  onPressed: toggleSettings,
                  icon: const Icon(Icons.settings),
                ),
                editable: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Do emit packages
              OpenMenuItem(
                height: 72,
                leading: Checkbox(
                  value: Settings.doSendPackages,
                  onChanged: (value) {
                    Settings.doSendPackages = value!;
                    if (mounted) setState(() {});
                  },
                ),
                editable: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Do send packages'),
                ),
              ),
              // Transmission Time
              OpenMenuItem(
                leading: const Icon(Icons.connect_without_contact),
                height: 72,
                editable: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latency: ${Settings.transmissionTime}ms',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Slider(
                        value: Settings.transmissionTime * 1.0,
                        min: 64,
                        max: 8192,
                        onChanged: (value) => setState(() {
                          Settings.transmissionTime = value.toInt();
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              // Window Size
              OpenMenuItem(
                leading: const Icon(Icons.view_carousel),
                height: 72,
                editable: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Window Size: ${Settings.windowSize}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Slider(
                        value: Settings.windowSize * 1.0,
                        min: 1,
                        max: 16,
                        onChanged: (value) => setState(() {
                          Settings.windowSize = value.toInt();
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              // Timeout
              OpenMenuItem(
                leading: const Icon(Icons.timer),
                height: 72,
                editable: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Timeout: ${Settings.timeout}ms',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              Settings.timeout < Settings.transmissionTime * 2
                                  ? Colors.red
                                  : Colors.black,
                        ),
                      ),
                      Slider(
                        value: Settings.timeout * 1.0,
                        min: 256,
                        max: 8192 * 2,
                        onChanged: (value) => setState(() {
                          Settings.timeout = value.toInt();
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              // Send Interval
              OpenMenuItem(
                leading: const Icon(Icons.timelapse),
                height: 72,
                editable: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send Interval: ${Settings.sendInterval}ms',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Slider(
                        value: Settings.sendInterval * 1.0,
                        min: 64,
                        max: 8192,
                        onChanged: (value) => setState(() {
                          Settings.sendInterval = value.toInt();
                          PackageFrameView.setTimer();
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              // Reset
              OpenMenuItem(
                leading: IconButton(
                  onPressed: reset,
                  icon: const Icon(Icons.refresh),
                ),
                onTap: reset,
                editable: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Reset',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
            showMenu: showSettings,
          ),
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
              elevation: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: PackageFrameView(scrollController: scrollController),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
