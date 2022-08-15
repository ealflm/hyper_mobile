import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HyperPositionStream {
  StreamSubscription<Position>? _positionStream;
  LocationSettings? _locationSettings;
  late Function() _onPositionChanged;

  HyperPositionStream({required Function() onPositionChanged}) {
    debugPrint('Map postion stream: init');
    _onPositionChanged = onPositionChanged;
    _init();
    pausePositionStream();
  }

  void _init() {
    _locationSettings = AndroidSettings();

    _positionStream =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen(
      (Position? position) async {
        debugPrint(position == null
            ? 'Map postion stream: unknown'
            : 'Map postion stream: ${position.latitude.toString()}, ${position.longitude.toString()}');

        await _onPositionChanged();
      },
    );
  }

  void pausePositionStream() {
    debugPrint('Map postion stream: pause');
    if (!(_positionStream?.isPaused ?? true)) {
      _positionStream?.pause();
    }
  }

  void resumePositionStream() {
    debugPrint('Map postion stream: resume');
    if (_positionStream?.isPaused ?? true) {
      _positionStream?.resume();
    }
  }

  void close() {
    _positionStream?.cancel();
  }
}
