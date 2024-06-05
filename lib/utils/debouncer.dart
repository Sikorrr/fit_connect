import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  Timer? _timer;
  final Duration debounceDuration;

  Debouncer({this.debounceDuration = const Duration(milliseconds: 300)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(debounceDuration, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
