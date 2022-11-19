import 'package:package_visual/animation/package.dart';
import 'package:package_visual/settings/protocol.dart';

/// The settings used for the creation of new [Package]s.
class Settings {
  /// Whether packages start their animation.
  static bool doSendPackages = true;

  /// The [Protocol] used for transmission.
  static Protocol protocol = Protocol.goBackN;

  /// Time in milliseconds to travel from sender to receiver (and bacl).
  static int transmissionTime = 4048;

  /// The number of packages that are contained in a Frame.
  static int windowSize = 8;

  /// Time in milliseconds before a package times out.
  static int timeout = 9192;

  /// Time in milliseconds between sending packages.
  static int sendInterval = 512;

  /// The currently active [Package]s.
  static final List<Package> packages = [];

  /// The index of the first not yet confirmed package.
  static int currentSendFrame = 0;

  /// The index of the first not yet received package.
  static int currentReceiveFrame = 0;

  static void reset() {
    doSendPackages = true;
    protocol = Protocol.goBackN;
    transmissionTime = 4069;
    windowSize = 4;
    timeout = 8192;
    sendInterval = 1024;
    packages.clear();
    currentSendFrame = 0;
    currentReceiveFrame = 0;
  }
}
