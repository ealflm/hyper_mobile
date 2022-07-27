import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:latlong2/latlong.dart';

class AnimatedMapController extends GetxController {
  late MapController controller;
  late TickerProvider vsync;

  AnimatedMapController({
    required this.controller,
    required this.vsync,
  });

  move(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: controller.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: controller.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: controller.zoom, end: destZoom);

    var animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: vsync);

    Animation<double> animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);

    animationController.addListener(() {
      controller.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.dispose();
      } else if (status == AnimationStatus.dismissed) {
        animationController.dispose();
      }
    });

    animationController.forward();
  }
}
