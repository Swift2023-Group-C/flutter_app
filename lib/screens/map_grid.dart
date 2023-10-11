import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_app/components/widgets/map.dart';

import '../repository/find_rooms_in_use.dart';
import '../repository/get_room_from_firebase.dart';
import '../repository/read_schedule_file.dart';

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
        return GridMaps.mapTileListMap[gridMapsList[widget.mapIndex]]![index]
            .tileWidget();
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
        List<String> resourceIds = findRoomsInUse(fileContent);
        //テスト用
        resourceIds.add('1');
        resourceIds.add('2');

        if (resourceIds.isNotEmpty) {
          for (String resourceId in resourceIds) {
            print("ResourceId: $resourceId");

            setState(() {
              final tilesList =
                  GridMaps.mapTileListMap[gridMapsList[widget.mapIndex]];
              if (tilesList != null) {
                for (int i = 0; i < tilesList.length; i++) {
                  if (tilesList[i].classroomNo == resourceId) {
                    // タイルの色をTileColors.usingに変更したい
                    tilesList[i] = Tile(tilesList[i].width, tilesList[i].height,
                        TileColors.using,
                        top: tilesList[i].top,
                        right: tilesList[i].right,
                        bottom: tilesList[i].bottom,
                        left: tilesList[i].left,
                        txt: tilesList[i].txt,
                        classroomNo: tilesList[i].classroomNo);
                  }
                }
              }
            });
          }
        } else {
          print("No ResourceId exists for the current time.");
        }
      } catch (e) {
        print(e);
      }
    });
  }
}
