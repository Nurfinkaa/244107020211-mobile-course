import 'package:flutter_riverpod/legacy.dart';

/// Toggle ini mensimulasikan kondisi offline secara deterministik,
/// tanpa perlu bergantung pada WiFi/mode pesawat sungguhan.
/// Berguna untuk demo dan testing yang konsisten.
final forceOfflineProvider = StateProvider<bool>((ref) => false);