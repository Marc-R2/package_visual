import 'package:flutter/material.dart';
import 'package:package_visual/openMenu/open_menu_item.dart';
import 'package:package_visual/openMenu/open_menu_widget.dart';
import 'package:package_visual/package_frame_view.dart';

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
  int _counter = 0;

  static int currentSendFrame = 4;
  static int currentReceiveFrame = 6;
  static int frameSize = 5;

  bool showSettings = false;

  void toggleSettings() {
    setState(() {
      showSettings = !showSettings;
    });
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
              margin: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
              elevation: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: PackageFrameView(
                  currentSendFrame: currentSendFrame,
                  currentReceiveFrame: currentReceiveFrame,
                  frameSize: frameSize,
                  counter: _counter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
