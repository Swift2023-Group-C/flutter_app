import 'package:flutter/material.dart';
import 'package:flutter_app/screens/map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_app/components/widgets/map.dart';

import 'package:flutter_app/repository/find_rooms_in_use.dart';
import 'package:flutter_app/repository/download_file_from_firebase.dart';
import 'package:flutter_app/repository/read_json_file.dart';

class MapGridScreen extends StatefulWidget {
  const MapGridScreen({Key? key}) : super(key: key);

  @override
  State<MapGridScreen> createState() => _MapGridScreenState();
}

class _MapGridScreenState extends State<MapGridScreen> {
  final List<String> gridMapsList = ["1", "2", "3", "4", "5", "R1", "R2"];
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final int floorIndex =
          ref.watch(mapPageProvider.select((state) => state.mapFloorCount));
      return StaggeredGridView.countBuilder(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 48,
        itemCount: GridMaps.mapTileListMap[gridMapsList[floorIndex]]!.length,
        itemBuilder: (BuildContext context, int index) {
          return GridMaps.mapTileListMap[gridMapsList[floorIndex]]![index];
        },
        staggeredTileBuilder: (int index) {
          return GridMaps.mapTileListMap[gridMapsList[floorIndex]]![index]
              .staggeredTile();
        },
      );
    });
  }

  @override
  void initState() {
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
    super.initState();
    // アプリ起動時に一度だけ実行される
    // initState内で非同期処理を行うための方法
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String scheduleFilePath = 'map/oneweek_schedule.json';
      // Firebaseからファイルをダウンロード
      await downloadFileFromFirebase(scheduleFilePath);

      // ダウンロードしたファイルの中身を読み取る
      try {
        String fileContent = await readJsonFile(scheduleFilePath);
        Map<String, DateTime> resourceIds = findRoomsInUse(fileContent);

        if (resourceIds.isNotEmpty) {
          resourceIds.forEach((String resourceId, DateTime useEndTime) {
            print(resourceId);
            if (classroomNoFloorMap.containsKey(resourceId)) {
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
            }
          });
        } else {
          print("No ResourceId exists for the current time.");
        }
      } catch (e) {
        print(e);
      }
    });
  }
}
