import 'package:package_visual/settings/settings_controller.dart';

class Package {
  const Package({
    required this.index,
    required this.startTime,
    required this.receiveTime,
    required this.confirmationTime,
    required this.timeoutTime,
    required this.isReceived,
    required this.isConfirmed,
    required this.isDestroyed,
  });

  /// Create a [Package] from the current [Settings].
  static Package fromSettings({required int index}) {
    final now = DateTime.now();
    final transmissionTime = Duration(milliseconds: Settings.transmissionTime);

    return Package(
      index: index,
      startTime: now,
      receiveTime: now.add(transmissionTime),
      confirmationTime: now.add(transmissionTime * 2),
      timeoutTime: now.add(Duration(milliseconds: Settings.timeout)),
      isReceived: false,
      isConfirmed: false,
      isDestroyed: false,
    );
  }

  /// The index of the package.
  final int index;

  /// Time when the package was sent.
  final DateTime startTime;

  /// Theoretical time when the package is received.
  final DateTime receiveTime;

  /// Theoretical time when the package is confirmed.
  final DateTime confirmationTime;

  /// The time at which the sender waiting for a confirmation times out.
  final DateTime timeoutTime;

  /// Whether the package is received.
  final bool isReceived;

  /// Whether the package is confirmed.
  final bool isConfirmed;

  /// Whether the package is destroyed.
  final bool isDestroyed;

  /// Get the current [DateTime].
  DateTime get now => DateTime.now();

  /// Whether the package has returned to the sender (by time).
  /// Whether the package has actually been received is not checked.
  bool get isDone => now.isAfter(confirmationTime);

  /// Whether the package has timed out (from the senders view).
  bool get isTimedOut => DateTime.now().isAfter(timeoutTime);

  /// Get the current progress of the transmission timeout.
  double get timeOutProgress => now.isAfter(timeoutTime)
      ? 1
      : now.difference(startTime).inMilliseconds /
          timeoutTime.difference(startTime).inMilliseconds;

  /// Get the relative progress of the package to the receiver and back.
  double get packagePosition => now.isAfter(receiveTime)
      ? now.isAfter(confirmationTime)
          ? 0
          : 1 -
              now.difference(receiveTime).inMilliseconds /
                  confirmationTime.difference(receiveTime).inMilliseconds
      : now.difference(startTime).inMilliseconds /
          receiveTime.difference(startTime).inMilliseconds;

  Package copyWith({
    int? index,
    DateTime? startTime,
    DateTime? receiveTime,
    DateTime? confirmationTime,
    DateTime? timeoutTime,
    bool? isReceived,
    bool? isConfirmed,
    bool? isDestroyed,
  }) {
    return Package(
      index: index ?? this.index,
      startTime: startTime ?? this.startTime,
      receiveTime: receiveTime ?? this.receiveTime,
      confirmationTime: confirmationTime ?? this.confirmationTime,
      timeoutTime: timeoutTime ?? this.timeoutTime,
      isReceived: isReceived ?? this.isReceived,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      isDestroyed: isDestroyed ?? this.isDestroyed,
    );
  }
}
