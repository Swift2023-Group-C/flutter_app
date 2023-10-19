import 'package:flutter/material.dart';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_app/screens/map_grid.dart';
import 'package:flutter_app/components/map_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProviderScope(
            child: Stack(
      children: [
        SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: InteractiveViewer(
                maxScale: 10.0,
                transformationController:
                    MapController.instance.getController(),
                child: const Padding(
                  padding: EdgeInsets.all(30),
                  child: MapGridScreen(),
                ))),
        const FloorButton(),
      ],
    )));
  }
}

@immutable
class MapState {
  const MapState({this.mapFloorCount = 3});
  final int mapFloorCount;
  MapState copyWith({int? mapFloorCount}) {
    return MapState(mapFloorCount: mapFloorCount ?? this.mapFloorCount);
  }
}

class MapStateNotifier extends StateNotifier<MapState> {
  MapStateNotifier() : super(const MapState());

  void changeFloor(int floorIndex) {
    state = state.copyWith(mapFloorCount: floorIndex);
  }
}

final mapPageProvider = StateNotifierProvider<MapStateNotifier, MapState>(
    (ref) => MapStateNotifier());

class FloorButton extends StatelessWidget {
  const FloorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> floorBarString = ['1', '2', '3', '4', '5', 'R1', 'R2'];
    TextStyle floorBarTextStyle =
        const TextStyle(fontSize: 18.0, color: Colors.black87);
    TextStyle floorBarSelectedTextStyle =
        const TextStyle(fontSize: 18.0, color: customFunColor);
    double floorButtonWidth = (MediaQuery.of(context).size.width - 30 < 350)
        ? MediaQuery.of(context).size.width - 30
        : 350;
    double floorButtonHeight = 50;
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.grey.withOpacity(0.9),
            width: floorButtonWidth,
            height: floorButtonHeight,
            child: Consumer(builder: (context, ref, child) {
              final int floorIndex = ref.watch(
                  mapPageProvider.select((state) => state.mapFloorCount));
              final notifier = ref.read(mapPageProvider.notifier);
              return Row(
                children: [
                  for (int i = 0; i < 7; i++) ...{
                    SizedBox(
                      width: floorButtonWidth / 7,
                      height: floorButtonHeight,
                      child: Center(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              fixedSize:
                                  Size(floorButtonWidth / 7, floorButtonHeight),
                              backgroundColor:
                                  (floorIndex == i) ? Colors.black12 : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            onPressed: () {
                              notifier.changeFloor(i);
                            },
                            child: Center(
                                child: Text(
                              floorBarString[i],
                              style: (floorIndex == i)
                                  ? floorBarSelectedTextStyle
                                  : floorBarTextStyle,
                            ))),
                      ),
                    ),
                  }
                ],
              );
            }),
          ),
        ));
  }
}
