import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class AnimatedMapController {
  late MapController controller;
  late TickerProvider vsync;

  AnimatedMapController({
    required this.controller,
    required this.vsync,
  });

  void move(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: controller.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: controller.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: controller.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: vsync);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
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
