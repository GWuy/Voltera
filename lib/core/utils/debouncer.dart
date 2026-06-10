import 'dart:async';

import 'package:flutter/foundation.dart';

/// A simple debouncer that delays execution until a pause in calls.
///
/// Usage:
/// ```dart
/// final _debouncer = Debouncer(duration: Duration(milliseconds: 300));
///
/// void _onSearchChanged(String query) {
///   _debouncer.run(() => _performSearch(query));
/// }
///
/// @override
/// void dispose() {
///   _debouncer.dispose();
///   super.dispose();
/// }
/// ```
class Debouncer {
  Debouncer({this.duration = const Duration(milliseconds: 300)});

  final Duration duration;
  Timer? _timer;

  /// Schedules [action] to run after [duration] of inactivity.
  /// Any previously scheduled action is cancelled.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Cancels any pending action and releases resources.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  /// Whether a debounced action is currently pending.
  bool get isActive => _timer?.isActive ?? false;
}
