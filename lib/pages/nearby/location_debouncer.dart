import 'dart:async';

import 'package:flutter/material.dart';

class LocationDebouncer {
  final Duration delay;
  Timer? _timer;

  LocationDebouncer(this.delay);

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
