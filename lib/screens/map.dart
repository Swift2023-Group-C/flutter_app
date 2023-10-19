import 'package:flutter/material.dart';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_app/screens/map_grid.dart';
import 'package:flutter_app/components/map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int mapGridCount = 2;

  void onFloorBarTapped(int findex) {
    setState(() {
      mapGridCount = findex;
      print(MapController.instance.viewTransformationController.value);
    });
  }

  final viewTransformationController = TransformationController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double floorButtonWidth = (MediaQuery.of(context).size.width - 30 < 350)
        ? MediaQuery.of(context).size.width - 30
        : 350;
    double floorButtonHeight = 50;
    var floorBarTextStyle =
        const TextStyle(fontSize: 18.0, color: Colors.black87);
    var floorBarSelectedTextStyle =
        const TextStyle(fontSize: 18.0, color: customFunColor);
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
            padding: const EdgeInsets.only(top: 20),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.grey.withOpacity(0.9),
                width: floorButtonWidth,
                height: floorButtonHeight,
                child: Row(
                  children: [
                    for (int i = 0; i < 7; i++) ...{
                      SizedBox(
                        width: floorButtonWidth / 7,
                        height: floorButtonHeight,
                        child: Center(
                          child: TextButton(
                              style: TextButton.styleFrom(
                                fixedSize: Size(
                                    floorButtonWidth / 7, floorButtonHeight),
                                backgroundColor:
                                    (mapGridCount == i) ? Colors.black12 : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              onPressed: () {
                                onFloorBarTapped(i);
                              },
                              child: Center(
                                  child: Text(
                                floorBarString[i],
                                style: (mapGridCount == i)
                                    ? floorBarSelectedTextStyle
                                    : floorBarTextStyle,
                              ))),
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
