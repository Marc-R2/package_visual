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

  Timer? updateTimer;

  @override
  void initState() {
    setTimer();
    super.initState();
  }

  void setTimer() {
    updateTimer?.cancel();
    updateTimer = Timer.periodic(
      Duration(milliseconds: Settings.sendInterval),
      update,
    );
  }

  void toggleSettings() => setState(() => showSettings = !showSettings);

  int get sendPos => Settings.currentSendFrame;

  void update([Timer? t]) {
    print('update ${Settings.packages.keys}');
    final size = Settings.windowSize;

    for (var i = 0; i < size; i++) {
      final index = sendPos + i;
      final frame = Settings.packages[index];
      if (frame == null) {
        Settings.packages[index] = Package.fromSettings(index: index);
        break;
      }
      if (i == 0 && frame.isConfirmed) {
        i = -1;
        Settings.currentSendFrame++;
        Settings.packages.remove(index);
        continue;
      }
      if (frame.isTimedOut && !frame.isConfirmed) {
        Settings.packages[index] = Package.fromSettings(index: index);
        break;
      }
    }

    print('set state: $mounted');
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
            items: const [
              OpenMenuItem(
                leading: Icon(Icons.settings),
                editable: Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            showMenu: showSettings,
          ),
          Expanded(
            child: Card(
              margin: EdgeInsets.only(top: 16, right: 16, bottom: 16),
              elevation: 48,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: PackageFrameView(
                  items: Settings.packages,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
