import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'map_grid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int mapImageCount = 4;

  void onFloorBarTapped(int findex) {
    setState(() {
      mapImageCount = findex;
    });
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
            child: Center(
                child: InteractiveViewer(
              maxScale: 10.0,
              child: const MapGridScreen(),
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

  SvgPicture setMapImage() {
    List<String> mapImageName = [
      'map05.svg',
      'map04.svg',
      'map03.svg',
      'map02.svg',
      'map01.svg',
      'mapr2.svg',
      'mapr1.svg'
    ];
    if (mapImageCount > 6 || mapImageCount < 0) {
      return SvgPicture.asset('images/${mapImageName[4]}');
    } else {
      return SvgPicture.asset('images/${mapImageName[mapImageCount]}');
    }
  }
}
