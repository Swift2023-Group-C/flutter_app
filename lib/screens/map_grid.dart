import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MapGridScreen extends StatefulWidget {
  const MapGridScreen({Key? key}) : super(key: key);

  @override
  State<MapGridScreen> createState() => _MapGridScreenState();
}

abstract final class TileColors {
  static Color get room => Colors.grey.shade700;
  static Color get room2 => Colors.grey.shade500;
  static Color get road => Colors.grey.shade300;
  static const Color empty = Color.fromARGB(0, 0, 0, 0);
}

class Tile {
  final int width;
  final int height;
  final Color c;
  double top;
  double right;
  double bottom;
  double left;
  String txt;

  Tile(this.width, this.height, this.c,
      {this.top = 0,
      this.right = 0,
      this.bottom = 0,
      this.left = 0,
      this.txt = ''});

  StaggeredTile staggeredTile() {
    return StaggeredTile.count(width, height.toDouble());
  }

  _TileWidget _tileWidget() {
    return _TileWidget(
      c: c,
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      txt: txt,
    );
  }
}

class _MapGridScreenState extends State<MapGridScreen> {
  final List<Tile> _map03TileList = [
    Tile(12, 18, TileColors.room,
        txt: 'Gym', top: 1, right: 1, bottom: 1, left: 1),
    Tile(6, 6, TileColors.road, top: 1),
    Tile(30, 6, TileColors.empty),
    Tile(4, 4, TileColors.room2),
    Tile(2, 4, TileColors.road),
    Tile(6, 12, TileColors.room, top: 1, bottom: 1, left: 1),
    Tile(6, 12, TileColors.room, top: 1, right: 1, bottom: 1, left: 1),
    Tile(6, 2, TileColors.room, txt: 'Medical'),
    Tile(2, 12, TileColors.road),
    Tile(6, 2, TileColors.room),
    Tile(4, 3, TileColors.road),
    Tile(6, 4, TileColors.room, txt: 'Studio'),
    Tile(6, 1, TileColors.road),
    Tile(10, 2, TileColors.road),
    Tile(4, 2, TileColors.road),
    Tile(2, 2, TileColors.road),
    Tile(2, 7, TileColors.road),
    Tile(2, 7, TileColors.road),
    Tile(6, 7, TileColors.road),
    Tile(6, 2, TileColors.road),
    Tile(6, 6, TileColors.road),
    Tile(4, 4, TileColors.room),
    Tile(2, 4, TileColors.road),
    Tile(48, 6, TileColors.road),
  ];

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 48,
      itemCount: _map03TileList.length,
      itemBuilder: (BuildContext context, int index) {
        return _map03TileList[index]._tileWidget();
      },
      staggeredTileBuilder: (int index) {
        return _map03TileList[index].staggeredTile();
      },
    );
  }
}

class _TileWidget extends StatelessWidget {
  final Color c;
  final double top;
  final double right;
  final double bottom;
  final double left;
  final String txt;
  const _TileWidget(
      {Key? key,
      required this.c,
      this.top = 0,
      this.right = 0,
      this.bottom = 0,
      this.left = 0,
      this.txt = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border(
            top: (top > 0) ? BorderSide(width: top) : BorderSide.none,
            right: (right > 0) ? BorderSide(width: right) : BorderSide.none,
            bottom: (bottom > 0) ? BorderSide(width: bottom) : BorderSide.none,
            left: (left > 0) ? BorderSide(width: left) : BorderSide.none),
        color: c,
      ),
      child: Center(
          child: Text(
        txt,
        style: TextStyle(
            color: (c == TileColors.room) ? Colors.white : Colors.black),
      )),
    );
  }
}
