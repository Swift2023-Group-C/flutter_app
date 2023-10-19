import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_app/components/widgets/map.dart';

import 'package:flutter_app/repository/find_rooms_in_use.dart';
import 'package:flutter_app/repository/get_room_from_firebase.dart';
import 'package:flutter_app/repository/read_schedule_file.dart';

class MapGridScreen extends StatefulWidget {
  final int mapIndex;
  const MapGridScreen({Key? key, this.mapIndex = 2}) : super(key: key);

  @override
  State<MapGridScreen> createState() => _MapGridScreenState();
}

class _MapGridScreenState extends State<MapGridScreen> {
  final List<String> gridMapsList = ["5", "4", "3", "2", "1", "r2", "r1"];
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 48,
      itemCount: GridMaps.mapTileListMap[gridMapsList[widget.mapIndex]]!.length,
      itemBuilder: (BuildContext context, int index) {
        return GridMaps.mapTileListMap[gridMapsList[widget.mapIndex]]![index];
      },
      staggeredTileBuilder: (int index) {
        return GridMaps.mapTileListMap[gridMapsList[widget.mapIndex]]![index]
            .staggeredTile();
      },
    );
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
      "7": ["r2"],
      "8": ["4"],
      "9": ["4"],
      "10": ["4"],
      "11": ["5"],
      "12": ["5"],
      "13": ["5"],
      "14": ["r2"],
      "15": ["r2"],
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
      // Firebaseからファイルをダウンロード
      await downloadFileFromFirebase();

      // ダウンロードしたファイルの中身を読み取る
      try {
        String fileContent = await readScheduleFile();
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
