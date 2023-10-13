import 'package:flutter/material.dart';

class MapController {
  MapController._();
  static final MapController instance = MapController._();
  TransformationController viewTransformationController =
      TransformationController(
          Matrix4(2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1, 0, -300, -300, 0, 1));

  TransformationController getController() {
    return viewTransformationController;
  }

  double getZoomRatio() {
    return viewTransformationController.value.getMaxScaleOnAxis();
  }
}
