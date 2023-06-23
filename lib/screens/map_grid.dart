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
  static Color get toilet => Colors.red.shade300;
  static Color get stair => Colors.blueGrey.shade600;
  static Color get ev => Colors.blueGrey.shade700;
  static const Color empty = Colors.transparent;
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
      {this.top = 1,
      this.right = 1,
      this.bottom = 1,
      this.left = 1,
      this.txt = ''});

  StaggeredTile staggeredTile() {
    return StaggeredTile.count(width, height.toDouble());
  }

  _TileWidget _tileWidget() {
    if (c == TileColors.empty) {
      if (top == 1) {
        top = 0;
      }
      if (right == 1) {
        right = 0;
      }
      if (bottom == 1) {
        bottom = 0;
      }
      if (left == 1) {
        left = 0;
      }
    }
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
    Tile(12, 18, TileColors.room, txt: 'Gym', top: 1.5, left: 1.5, bottom: 0),
    Tile(6, 6, TileColors.road, top: 1.5, left: 0, right: 0),
    Tile(30, 6, TileColors.empty, left: 1.5, bottom: 1.5),
    Tile(4, 4, TileColors.toilet), // 体育館トイレ
    Tile(2, 4, TileColors.road),
    Tile(6, 12, TileColors.room, txt: '工房'),
    Tile(6, 12, TileColors.room, txt: 'E工房'),
    Tile(6, 2, TileColors.room, txt: 'Medical'),
    Tile(2, 12, TileColors.road),
    Tile(6, 2, TileColors.room2),
    Tile(4, 3, TileColors.room2, right: 1.5, top: 0, bottom: 0),
    Tile(6, 4, TileColors.room, txt: 'Studio'),
    Tile(6, 1, TileColors.road),
    Tile(10, 2, TileColors.room2, right: 1.5, top: 0, bottom: 0),
    Tile(4, 2, TileColors.stair),
    Tile(2, 2, TileColors.road),
    Tile(2, 7, TileColors.toilet), // 駐車場側トイレ
    Tile(2, 7, TileColors.stair), // 事務局行き階段
    Tile(6, 7, TileColors.room, txt: 'Musium', right: 1.5, top: 0, bottom: 0),
    Tile(6, 2, TileColors.road),
    Tile(6, 6, TileColors.room, txt: 'グラフィック工房'),
    Tile(4, 4, TileColors.room2),
    Tile(2, 4, TileColors.road),
    Tile(48, 2, TileColors.road,
        top: 0, bottom: 0, left: 1.5, right: 1.5), // モール
    Tile(14, 2, TileColors.road, top: 0, bottom: 0, left: 1.5),
    Tile(2, 2, TileColors.stair), // モール体育館側階段
    Tile(18, 2, TileColors.road),
    Tile(2, 2, TileColors.ev), // モールエレベーター
    Tile(2, 2, TileColors.road),
    Tile(2, 2, TileColors.stair), // モール入口側階段
    Tile(8, 2, TileColors.road, top: 0, bottom: 0, right: 1.5),
    Tile(48, 2, TileColors.road,
        top: 0, bottom: 0, left: 1.5, right: 1.5), // モール
    Tile(12, 7, TileColors.room, txt: '大講義室', left: 1.5, top: 0, bottom: 0),
    Tile(1, 7, TileColors.room2),
    Tile(3, 5, TileColors.room2),
    Tile(2, 7, TileColors.road),
    Tile(6, 7, TileColors.room, txt: '365'),
    Tile(6, 7, TileColors.room, txt: '364'),
    Tile(6, 7, TileColors.room, txt: '363'),
    Tile(4, 2, TileColors.room2),
    Tile(2, 7, TileColors.road),
    Tile(6, 37, TileColors.room, txt: 'Library'),
    Tile(2, 5, TileColors.toilet), // 入口側トイレ男
    Tile(2, 5, TileColors.room2),
    Tile(3, 2, TileColors.room2),
    Tile(42, 1, TileColors.road, left: 1.5, top: 0, bottom: 0),
    Tile(1, 6, TileColors.road, left: 1.5, top: 0, bottom: 0),
    Tile(5, 2, TileColors.room2),
    Tile(6, 2, TileColors.room),
    Tile(4, 4, TileColors.toilet), // 331側トイレ
    Tile(2, 6, TileColors.road),
    Tile(6, 2, TileColors.room),
    Tile(6, 2, TileColors.room),
    Tile(4, 2, TileColors.room),
    Tile(2, 2, TileColors.room),
    Tile(4, 2, TileColors.toilet), // 入口側トイレ女
    Tile(2, 6, TileColors.road),
    Tile(1, 4, TileColors.room),
    Tile(2, 4, TileColors.room, txt: '335'),
    Tile(2, 4, TileColors.room, txt: '334'),
    Tile(2, 4, TileColors.room, txt: '333'),
    Tile(2, 4, TileColors.room, txt: '332'),
    Tile(2, 4, TileColors.room, txt: '331'),
    Tile(2, 4, TileColors.room, txt: '330'),
    Tile(2, 4, TileColors.room, txt: '329'),
    Tile(2, 4, TileColors.room, txt: '328'),
    Tile(2, 4, TileColors.room, txt: '327'),
    Tile(2, 4, TileColors.room, txt: '326'),
    Tile(2, 4, TileColors.room, txt: '325'),
    Tile(2, 4, TileColors.room, txt: '324'),
    Tile(2, 4, TileColors.room, txt: '323'),
    Tile(2, 4, TileColors.room, txt: '322'),
    Tile(2, 4, TileColors.room, txt: '321'),
    Tile(4, 2, TileColors.room),
    Tile(2, 4, TileColors.room),
    Tile(42, 1, TileColors.road, left: 1.5, top: 0, bottom: 0),
    Tile(12, 5, TileColors.room2, left: 1.5, top: 0, bottom: 0),
    Tile(4, 3, TileColors.road),
    Tile(2, 5, TileColors.stair), // 階段331側下り
    Tile(2, 2, TileColors.room2),
    Tile(1, 2, TileColors.road),
    Tile(14, 2, TileColors.room2),
    Tile(1, 2, TileColors.road),
    Tile(4, 3, TileColors.road),
    Tile(2, 5, TileColors.stair), // 階段321側下り
    Tile(18, 3, TileColors.road),
    Tile(2, 2, TileColors.road),
    Tile(2, 2, TileColors.stair), // 階段331側上り
    Tile(2, 2, TileColors.road),
    Tile(2, 2, TileColors.stair), // 階段321側上り
    Tile(36, 17, TileColors.empty, top: 1.5),
    Tile(2, 12, TileColors.road),
    Tile(4, 8, TileColors.empty),
    Tile(2, 2, TileColors.ev), // エレベーター
    Tile(2, 2, TileColors.empty),
    Tile(2, 1, TileColors.road),
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
      this.top = 1,
      this.right = 1,
      this.bottom = 1,
      this.left = 1,
      this.txt = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border(
            top: (top > 0)
                ? BorderSide(
                    width: top,
                    color: (top == 1.5) ? Colors.black : TileColors.road)
                : BorderSide.none,
            right: (right > 0)
                ? BorderSide(
                    width: right,
                    color: (right == 1.5) ? Colors.black : TileColors.road)
                : BorderSide.none,
            bottom: (bottom > 0)
                ? BorderSide(
                    width: bottom,
                    color: (bottom == 1.5) ? Colors.black : TileColors.road)
                : BorderSide.none,
            left: (left > 0)
                ? BorderSide(
                    width: left,
                    color: (left == 1.5) ? Colors.black : TileColors.road)
                : BorderSide.none),
        color: c,
      ),
      child: Center(
          child: Text(
        txt,
        style: TextStyle(
            color: (c == TileColors.room) ? Colors.white : Colors.black,
            fontSize: 8),
      )),
    );
  }
}
