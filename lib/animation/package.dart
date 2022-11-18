
import 'package:package_visual/settings/settings_controller.dart';

class Package {
  const Package({
    required this.index,
    required this.startTime,
    required this.receiveTime,
    required this.confirmationTime,
    required this.timeoutTime,
  });

  static Package fromSettings({required int index}) {
    final now = DateTime.now();
    final transmissionTime = Duration(milliseconds: Settings.transmissionTime);

    return Package(
      index: index,
      startTime: now,
      receiveTime: now.add(transmissionTime),
      confirmationTime: now.add(transmissionTime * 2),
      timeoutTime: now.add(Duration(milliseconds: Settings.timeout)),
    );
  }

  DateTime get now => DateTime.now();

  final int index;

  final DateTime startTime;

  final DateTime receiveTime;

  final DateTime confirmationTime;

  final DateTime timeoutTime;
}
