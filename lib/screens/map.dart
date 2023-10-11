import 'package:flutter/material.dart';
import 'map_grid.dart';
import 'package:flutter_app/components/map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int mapGridCount = 4;

  void onFloorBarTapped(int findex) {
    setState(() {
      mapGridCount = findex;
      print(MapController.instance.getZoomRatio());
    });
  }

  final viewTransformationController = TransformationController();

  @override
  void initState() {
    viewTransformationController.value =
        Matrix4(2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1, 0, -300, -100, 0, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double floorWidth = 40.0;
    var floorBarTextStyle = const TextStyle(fontSize: 18.0);
    List<String> floorBarString = ['5', '4', '3', '2', '1', 'R2', 'R1'];
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: InteractiveViewer(
                maxScale: 10.0,
                transformationController:
                    MapController.instance.getController(),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: MapGridScreen(mapIndex: mapGridCount),
                ))),
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                color: Colors.grey.withOpacity(0.8),
                height: 350,
                width: floorWidth,
                child: Column(
                  children: [
                    for (int i = 0; i < 7; i++) ...{
                      SizedBox(
                        width: floorWidth,
                        height: 50,
                        child: Center(
                          child: TextButton(
                              onPressed: () {
                                onFloorBarTapped(i);
                              },
                              child: Text(
                                floorBarString[i],
                                style: floorBarTextStyle,
                              )),
                        ),
                      ),
                    }
                  ],
                ),
              ),
            ))
      ],
    ));
  }
}
