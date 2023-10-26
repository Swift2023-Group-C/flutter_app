import 'package:flutter/material.dart';
import 'package:flutter_app/components/widgets/progress_indicator.dart';
import 'package:flutter_app/repository/download_file_from_firebase.dart';
import 'package:flutter_app/screens/map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_app/components/widgets/map.dart';

import 'package:flutter_app/repository/find_rooms_in_use.dart';
import 'package:flutter_app/repository/read_json_file.dart';

class MapGridScreen extends StatefulWidget {
  const MapGridScreen({Key? key}) : super(key: key);

  @override
  State<MapGridScreen> createState() => _MapGridScreenState();
}

class _MapGridScreenState extends State<MapGridScreen> {
  final List<String> gridMapsList = ["1", "2", "3", "4", "5", "R1", "R2"];
  Future<int?>? _future;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final mapPage = ref.watch(mapPageProvider);
      return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StaggeredGrid.count(
              crossAxisCount: 48,
              children: [
                ...GridMaps.mapTileListMap[gridMapsList[mapPage]]!.map(
                  (e) {
                    return StaggeredGridTile.count(
                        crossAxisCellCount: e.width,
                        mainAxisCellCount: e.height,
                        child: e);
                  },
                )
              ],
            );
          } else {
            return Center(
              child: createProgressIndicator(),
            );
          }
        },
      );
    });
  }

  Future<int?> initUsingColor() async {
    final Map<String, List<String>> classroomNoFloorMap = {
      "1": ["4", "5"],
      "2": ["3"],
      "3": ["4"],
      "4": ["5"],
      "5": ["5"],
      "6": ["5"],
      "7": ["R2"],
      "8": ["4"],
      "9": ["4"],
      "10": ["4"],
      "11": ["5"],
      "12": ["5"],
      "13": ["5"],
      "14": ["R2"],
      "15": ["R2"],
      "16": ["3"],
      "17": ["3"],
      "18": ["3"],
      "19": ["4"],
      "50": ["1"],
      "51": ["3"],
    };

    String scheduleFilePath = 'map/oneweek_schedule.json';
    // Firebaseからファイルをダウンロード
    await downloadFileFromFirebase(scheduleFilePath);
    Map<String, DateTime>? resourceIds;
    try {
      String fileContent = await readJsonFile(scheduleFilePath);
      resourceIds = findRoomsInUse(fileContent);
    } catch (e) {
      print(e);
    }

    if (resourceIds != null) {
      if (resourceIds.isNotEmpty) {
        resourceIds.forEach((String resourceId, DateTime useEndTime) {
          print(resourceId);
          if (classroomNoFloorMap.containsKey(resourceId)) {
            setState(() {
              for (var floor in classroomNoFloorMap[resourceId]!) {
                final tileIndex = GridMaps.mapTileListMap[floor]!
                    .indexWhere((tile) => tile.classroomNo == resourceId);
                if (tileIndex != -1) {
                  GridMaps.mapTileListMap[floor]![tileIndex].setUsing(true);
                  GridMaps.mapTileListMap[floor]![tileIndex]
                      .setTileColor(TileColors.using);
                  GridMaps.mapTileListMap[floor]![tileIndex]
                      .setFontColor(Colors.black);
                  GridMaps.mapTileListMap[floor]![tileIndex]
                      .setUseEndTime(useEndTime);
                }
              }
            });
          }
        });
        return 1;
      }
    } else {
      print("No ResourceId exists for the current time.");
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _future = initUsingColor();
  }
}
