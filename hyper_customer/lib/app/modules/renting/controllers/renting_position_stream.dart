import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RentingPositionStream {
  StreamSubscription<Position>? positionStream;
  LocationSettings? locationSettings;

  RentingPositionStream() {
    _init();
  }

  void _init() {
    locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      forceLocationManager: true,
      //(Optional) Set foreground notification config to keep the app alive
      //when going to the background
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText:
            "Example app will continue to receive your location even when you aren't using it",
        notificationTitle: "Running in Background",
        enableWakeLock: true,
      ),
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) async {
        debugPrint(position == null
            ? 'Unknown'
            : '${position.latitude.toString()}, ${position.longitude.toString()}');

        // if (rentingState.value == RentingState.navigation &&
        //     isFlowingMode.value) {
        //   await _mapLocationController.loadLocation();

        //   _goToCurrentLocation(zoom: RentingConstant.navigationModeZoomLevel);

        //   _getSelectedLegIndex(position?.latitude, position?.longitude);
        // }
      },
    );
  }
}
