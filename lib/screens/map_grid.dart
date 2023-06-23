import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_app/components/widgets/map.dart';

class MapGridScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 48,
      itemCount: gridMapsList[mapIndex].length,
      itemBuilder: (BuildContext context, int index) {
        return gridMapsList[mapIndex][index].tileWidget();
      },
      staggeredTileBuilder: (int index) {
        return gridMapsList[mapIndex][index].staggeredTile();
      },
    );
  }
}
