import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_visual/animation/package.dart';
import 'package:package_visual/openMenu/open_menu_item.dart';
import 'package:package_visual/openMenu/open_menu_widget.dart';
import 'package:package_visual/package_frame_view.dart';
import 'package:package_visual/settings/settings_controller.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
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
              const OpenMenuItem(
                leading: Icon(Icons.settings),
                editable: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Transmission Time
              OpenMenuItem(
                leading: const Icon(Icons.connect_without_contact),
                editable: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Latency: ${Settings.transmissionTime}ms',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              // Window Size
              OpenMenuItem(
                leading: const Icon(Icons.view_carousel),
                editable: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Window Size: ${Settings.windowSize}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              // Timeout
              OpenMenuItem(
                leading: const Icon(Icons.timer),
                editable: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Timeout: ${Settings.timeout}ms',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              // Send Interval
              OpenMenuItem(
                leading: const Icon(Icons.timelapse),
                editable: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Send Interval: ${Settings.sendInterval}ms',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              // Reset
              OpenMenuItem(
                leading: const Icon(Icons.refresh),
                onTap: () async {
                  await scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 512),
                    curve: Curves.easeInOutCirc,
                  );
                  Settings.reset();
                  if (mounted) setState(() {});
                },
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
