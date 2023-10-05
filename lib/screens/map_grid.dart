import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_app/components/widgets/map.dart';

import '../repository/find_rooms_in_use.dart';
import '../repository/get_room_from_firebase.dart';
import '../repository/read_schedule_file.dart';

class MapGridScreen extends StatefulWidget {
  final int mapIndex;
  const MapGridScreen({Key? key, this.mapIndex = 2}) : super(key: key);

  static List<List<Tile>> gridMapsList = [
    GridMaps.map05TileList,
    GridMaps.map04TileList,
    GridMaps.map03TileList,
    GridMaps.map02TileList,
    GridMaps.map01TileList,
    GridMaps.mapr2TileList,
    GridMaps.mapr1TileList
  ];

  @override
  State<MapGridScreen> createState() => _MapGridScreenState();
}

class _MapGridScreenState extends State<MapGridScreen> {
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 48,
      itemCount: MapGridScreen.gridMapsList[widget.mapIndex].length,
      itemBuilder: (BuildContext context, int index) {
        return MapGridScreen.gridMapsList[widget.mapIndex][index].tileWidget();
      },
      staggeredTileBuilder: (int index) {
        return MapGridScreen.gridMapsList[widget.mapIndex][index]
            .staggeredTile();
      },
    );
  }

  @override
  void initState() {
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
            // ここで取得したresourceIdをつかえるとおもう
            // 講堂でテスト
            if (resourceIds.contains('1')) {
              setState(() {
                final tileIndex = GridMaps.map04TileList
                    .indexWhere((tile) => tile.txt == '講堂');

                if (tileIndex != -1) {
                  GridMaps.map04TileList[tileIndex] =
                      Tile(6, 12, TileColors.using, txt: '講堂');
                }
              });
            }

            if (resourceIds.contains('2')) {
              setState(() {
                final tileIndex = GridMaps.map04TileList
                    .indexWhere((tile) => tile.txt == '495');

                if (tileIndex != -1) {
                  GridMaps.map04TileList[tileIndex] =
                      Tile(6, 6, TileColors.using, txt: '495');
                }
              });
            }
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
