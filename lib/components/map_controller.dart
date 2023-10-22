import 'package:flutter/material.dart';

class MapController {
  MapController._();
  static final MapController instance = MapController._();
  TransformationController viewTransformationController =
      TransformationController(
          Matrix4(1.5, 0, 0, 0, 0, 1.5, 0, 0, 0, 0, 1, 0, -100, -250, 0, 1));

  TransformationController getController() {
    return viewTransformationController;
  }

  double getZoomRatio() {
    return viewTransformationController.value.getMaxScaleOnAxis();
  }
}
