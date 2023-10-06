import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

abstract final class TileColors {
  static Color get room => Colors.grey.shade700;
  static Color get room2 => Colors.grey.shade500;
  static Color get road => Colors.grey.shade300;
  static Color get toilet => Colors.red.shade300;
  static Color get stair => Colors.blueGrey.shade600;
  static Color get ev => Colors.blueGrey.shade700;
  static Color get using => Colors.yellow.shade500;
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
  String? classroomNo;

  Tile(
    this.width,
    this.height,
    this.c, {
    this.top = 1,
    this.right = 1,
    this.bottom = 1,
    this.left = 1,
    this.txt = '',
    this.classroomNo,
  });

  StaggeredTile staggeredTile() {
    return StaggeredTile.count(width, height.toDouble());
  }

  TileWidget tileWidget() {
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
    return TileWidget(
      c: c,
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      txt: txt,
    );
  }
}

class TileWidget extends StatelessWidget {
  final Color c;
  final double top;
  final double right;
  final double bottom;
  final double left;
  final String txt;
  const TileWidget(
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
            fontSize: 7),
      )),
    );
  }
}

abstract final class GridMaps {
  static final List<Tile> map04TileList = [
    Tile(12, 18, TileColors.room,
        txt: 'Gym', top: 1.5, left: 1.5, right: 0, bottom: 1.5),
    //Tile(6, 6, TileColors.empty, left: 1.5),  一応吹き抜けでトレーニングルーム見える
    Tile(36, 6, TileColors.empty, left: 1.5, bottom: 1.5),
    Tile(1, 6, TileColors.road),
    Tile(3, 4, TileColors.toilet, txt: 'wc'),
    Tile(2, 6, TileColors.empty),
    Tile(6, 6, TileColors.room, txt: '495'),
    Tile(6, 6, TileColors.room, txt: '494'),
    Tile(6, 6, TileColors.room, txt: '493'),
    Tile(6, 6, TileColors.room2),
    Tile(1, 6, TileColors.road),
    Tile(5, 10, TileColors.room, txt: '事務局', top: 0, right: 1.5),
    Tile(3, 2, TileColors.stair),
    Tile(31, 1, TileColors.road),
    Tile(1, 13, TileColors.road),
    Tile(3, 5, TileColors.room2),
    Tile(2, 5, TileColors.empty),
    Tile(6, 5, TileColors.room, txt: '485'),
    Tile(6, 5, TileColors.room, txt: '484'),
    Tile(6, 5, TileColors.room, txt: '483'),
    Tile(1, 13, TileColors.road),
    Tile(3, 5, TileColors.toilet, txt: 'wc'),
    Tile(2, 5, TileColors.stair),
    Tile(1, 5, TileColors.road),
    Tile(5, 2, TileColors.room, txt: '局長室'),
    Tile(12, 6, TileColors.empty),
    Tile(23, 2, TileColors.empty),
    Tile(5, 2, TileColors.empty),
    Tile(1, 8, TileColors.road),
    Tile(5, 6, TileColors.empty),
    Tile(2, 2, TileColors.stair),
    Tile(19, 2, TileColors.empty),
    Tile(2, 2, TileColors.ev, txt: 'ev'),
    Tile(2, 2, TileColors.stair),
    Tile(3, 2, TileColors.empty),
    Tile(23, 2, TileColors.empty),
    Tile(5, 2, TileColors.empty),
    Tile(2, 2, TileColors.room2, txt: 'S-15'), //文字はみ出してる
    Tile(2, 2, TileColors.room2, txt: 'S-14'),
    Tile(2, 2, TileColors.room2, txt: 'S-13'),
    Tile(2, 2, TileColors.room2, txt: 'S-12'),
    Tile(2, 2, TileColors.room2, txt: 'S-11'),
    Tile(2, 2, TileColors.room2, txt: 'S-10'),
    Tile(2, 2, TileColors.room2),
    Tile(1, 2, TileColors.room2, txt: '湯'),
    Tile(2, 2, TileColors.room2),
    Tile(2, 2, TileColors.room2, txt: 'S-9'),
    Tile(2, 2, TileColors.room2, txt: 'S-8'),
    Tile(2, 2, TileColors.room2, txt: 'S-7'),
    Tile(2, 2, TileColors.room2, txt: 'S-6'),
    Tile(2, 2, TileColors.room2, txt: 'S-5'),
    Tile(2, 2, TileColors.room2, txt: 'S-4'),
    Tile(2, 2, TileColors.room2, txt: 'S-3'),
    Tile(2, 2, TileColors.room2, txt: 'S-2'),
    Tile(2, 2, TileColors.room2, txt: 'S-1'),
    Tile(2, 2, TileColors.room2),
    Tile(1, 2, TileColors.room2, txt: '倉庫'),
    Tile(2, 2, TileColors.room2),
    Tile(2, 2, TileColors.room2),
    Tile(3, 3, TileColors.room2, txt: '理事室'),
    Tile(43, 1, TileColors.road),
    Tile(2, 5, TileColors.room2, txt: '秘書室'),
    Tile(1, 4, TileColors.road),
    Tile(1, 4, TileColors.room2, txt: '倉庫'),
    Tile(2, 4, TileColors.room2, txt: '435'),
    Tile(2, 4, TileColors.room2, txt: '434'),
    Tile(2, 4, TileColors.room2, txt: '433'),
    Tile(2, 4, TileColors.room2, txt: '432'),
    Tile(2, 4, TileColors.room2, txt: '431'),
    Tile(1, 4, TileColors.road),
    Tile(3, 3, TileColors.toilet, txt: 'WC'),
    Tile(2, 10, TileColors.room2),
    Tile(1, 2, TileColors.room2, txt: '印刷'),
    Tile(1, 4, TileColors.road),
    Tile(2, 4, TileColors.room2, txt: '429'),
    Tile(2, 4, TileColors.room2, txt: '428'),
    Tile(2, 4, TileColors.room2, txt: '427'),
    Tile(2, 4, TileColors.room2, txt: '426'),
    Tile(2, 4, TileColors.room2, txt: '425'),
    Tile(2, 4, TileColors.room2, txt: '424'),
    Tile(2, 4, TileColors.room2, txt: '423'),
    Tile(2, 4, TileColors.room2, txt: '422'),
    Tile(1, 4, TileColors.road),
    Tile(3, 3, TileColors.toilet, txt: 'WC'),
    Tile(2, 10, TileColors.empty),
    Tile(3, 4, TileColors.room2, txt: '学長室'),
    Tile(13, 1, TileColors.road),
    Tile(3, 1, TileColors.room2),
    Tile(1, 9, TileColors.road),
    Tile(1, 2, TileColors.room2, txt: '倉庫'),
    Tile(3, 1, TileColors.room2),
    Tile(3, 3, TileColors.room2, txt: 'M402'),
    Tile(22, 1, TileColors.road),
    Tile(5, 4, TileColors.room2, txt: '特別応接室'),
    Tile(12, 5, TileColors.room2),
    Tile(1, 5, TileColors.road),
    Tile(18, 3, TileColors.room2),
    Tile(4, 5, TileColors.room2, txt: 'ラウンジ'),
    Tile(3, 3, TileColors.room2, txt: 'M401'),
    Tile(6, 2, TileColors.room2),
    Tile(6, 2, TileColors.room, txt: 'メタ学習ラボ'),
    Tile(6, 2, TileColors.room2),
    Tile(4, 1, TileColors.room2),
    Tile(1, 1, TileColors.road),
    Tile(6, 1, TileColors.road),
    Tile(12, 25, TileColors.empty),
    Tile(2, 6, TileColors.road),
    Tile(22, 4, TileColors.empty),
    Tile(2, 6, TileColors.road),
    Tile(4, 4, TileColors.empty),
    Tile(1, 6, TileColors.road),
    Tile(3, 3, TileColors.room2, txt: 'サーバーコンピュータ事務室'),
    Tile(2, 3, TileColors.toilet, txt: 'WC'),
    Tile(5, 3, TileColors.room2, txt: 'サーバーコンピュータ室'),
    Tile(2, 2, TileColors.stair),
    Tile(20, 2, TileColors.empty),
    Tile(2, 2, TileColors.stair),
    Tile(2, 2, TileColors.empty),
    Tile(26, 1, TileColors.road),
    Tile(4, 8, TileColors.empty),
    Tile(6, 12, TileColors.room, txt: '講堂'),
    Tile(2, 11, TileColors.road),
    Tile(4, 11, TileColors.room, txt: 'デルタ'),
    Tile(18, 10, TileColors.empty),
    Tile(2, 9, TileColors.road),
    Tile(2, 2, TileColors.ev, txt: 'ev'),
    Tile(2, 2, TileColors.empty),
    Tile(30, 7, TileColors.empty),
    Tile(6, 7, TileColors.room2, txt: 'なんかある？'),
  ];
  static final List<Tile> map05TileList = [
    Tile(13, 2, TileColors.room2), //サークル1
    Tile(3, 2, TileColors.room2), //サークル2
    Tile(2, 12, TileColors.toilet), //吹き抜け
    Tile(30, 6, TileColors.empty), //empty
    Tile(13, 1, TileColors.road),
    Tile(3, 8, TileColors.room2), //サークル3
    Tile(1, 14, TileColors.road),
    Tile(11, 14, TileColors.empty), //empty gym
    Tile(1, 9, TileColors.road),
    Tile(6, 6, TileColors.room, txt: '595'),
    Tile(6, 6, TileColors.room, txt: '594'),
    Tile(6, 6, TileColors.room, txt: '593'),
    Tile(6, 6, TileColors.empty), //吹き抜け
    Tile(6, 12, TileColors.room2),
    Tile(3, 2, TileColors.stair), // 階段体育館側
    Tile(30, 1, TileColors.road),
    Tile(1, 4, TileColors.road),
    Tile(3, 5, TileColors.toilet), // 585トイレ
    Tile(2, 5, TileColors.toilet), //吹き抜け
    Tile(6, 5, TileColors.room, txt: '585'),
    Tile(6, 5, TileColors.room, txt: '584'),
    Tile(6, 5, TileColors.room, txt: '583'),
    Tile(1, 5, TileColors.road),
    Tile(3, 5, TileColors.room2), // 583側トイレ
    Tile(2, 5, TileColors.empty), //吹き抜け
    Tile(13, 1, TileColors.road),
    Tile(12, 6, TileColors.empty), //empty left
    Tile(1, 6, TileColors.road),
    Tile(23, 2, TileColors.empty), //empty center1
    Tile(1, 6, TileColors.road),
    Tile(11, 2, TileColors.empty), //empty right1
    Tile(2, 2, TileColors.stair), // 階段center側
    Tile(19, 2, TileColors.empty), //empty center2
    Tile(2, 2, TileColors.ev), // エレベーターcenter
    Tile(2, 2, TileColors.stair), // 階段right側
    Tile(9, 2, TileColors.empty), //empty right2
    Tile(23, 2, TileColors.empty), //empty center3
    Tile(11, 2, TileColors.empty), //empty right3
    Tile(37, 1, TileColors.road),
    Tile(3, 5, TileColors.room2),
    Tile(2, 5, TileColors.empty), //吹き抜け
    Tile(2, 5, TileColors.road),
    Tile(4, 8, TileColors.room2),
    Tile(2, 4, TileColors.room, txt: '536'),
    Tile(2, 4, TileColors.room, txt: '535'),
    Tile(2, 4, TileColors.room, txt: '534'),
    Tile(2, 4, TileColors.room, txt: '533'),
    Tile(2, 4, TileColors.room, txt: '532'),
    Tile(2, 4, TileColors.room, txt: '531'),
    Tile(1, 4, TileColors.toilet),
    Tile(3, 4, TileColors.room2),
    Tile(2, 4, TileColors.empty), //吹き抜け
    Tile(1, 4, TileColors.room2),
    Tile(1, 4, TileColors.road),
    Tile(2, 4, TileColors.room, txt: '529'),
    Tile(2, 4, TileColors.room, txt: '528'),
    Tile(2, 4, TileColors.room, txt: '527'),
    Tile(2, 4, TileColors.room, txt: '526'),
    Tile(2, 4, TileColors.room, txt: '525'),
    Tile(2, 4, TileColors.room, txt: '524'),
    Tile(2, 4, TileColors.room, txt: '523'),
    Tile(2, 4, TileColors.room, txt: '522'),
    Tile(1, 4, TileColors.road),
    Tile(44, 1, TileColors.road),
    Tile(12, 2, TileColors.room2), //スタジオleft
    Tile(2, 2, TileColors.road),
    Tile(2, 2, TileColors.room2),
    Tile(2, 2, TileColors.empty), //吹き抜け
    Tile(18, 2, TileColors.room2), //スタジオcenter
    Tile(2, 11, TileColors.road),
    Tile(2, 2, TileColors.room2),
    Tile(2, 2, TileColors.empty), //吹き抜け
    Tile(2, 4, TileColors.road),
    Tile(12, 12, TileColors.empty), //empty left
    Tile(2, 12, TileColors.road),
    Tile(22, 10, TileColors.empty), //empty center
    Tile(4, 9, TileColors.empty), //empty right
    Tile(4, 2, TileColors.room2),
    Tile(6, 2, TileColors.road),
    Tile(1, 5, TileColors.road),
    Tile(4, 2, TileColors.room2),
    Tile(1, 5, TileColors.road),
    Tile(4, 3, TileColors.toilet), // 講堂側トイレ
    Tile(12, 1, TileColors.road),
    Tile(2, 2, TileColors.stair), // 階段center側
    Tile(20, 2, TileColors.empty), //empty center
    Tile(2, 2, TileColors.road),
    Tile(2, 2, TileColors.stair), // 階段講堂側
    Tile(2, 2, TileColors.empty), //empty 階段横
    Tile(1, 2, TileColors.road),
    Tile(4, 2, TileColors.room2), //調光室
    Tile(1, 2, TileColors.road),
    Tile(36, 12, TileColors.empty), //empty big1
    Tile(2, 12, TileColors.road), //empty big1
    Tile(4, 8, TileColors.empty), //empty 講堂１
    Tile(6, 12, TileColors.room, txt: '講堂'),
    Tile(2, 2, TileColors.ev), // エレベーター
    Tile(2, 2, TileColors.empty), //empty ev横
    Tile(4, 2, TileColors.empty), //empty ev下
    Tile(42, 7, TileColors.empty), //empty ev横
    Tile(6, 7, TileColors.empty), //empty
  ];
  static final List<Tile> mapr1TileList = [];
  static final List<Tile> mapr2TileList = [
    Tile(4, 2, TileColors.room, txt: 'R711'),
    Tile(1, 30, TileColors.road),
    Tile(3, 3, TileColors.empty),
    Tile(2, 3, TileColors.room2),
    Tile(5, 3, TileColors.empty),
    Tile(2, 9, TileColors.room2),
    Tile(4, 9, TileColors.empty),
    Tile(1, 14, TileColors.road),
    Tile(4, 2, TileColors.room, txt: 'R757'),
    Tile(22, 20, TileColors.empty),
    Tile(4, 2, TileColors.room, txt: 'R710'),
    Tile(4, 2, TileColors.room, txt: 'R756'),
    Tile(6, 1, TileColors.road),
    Tile(2, 22, TileColors.road),
    Tile(2, 6, TileColors.empty),
    Tile(4, 2, TileColors.road),
    Tile(6, 4, TileColors.empty),
    Tile(4, 2, TileColors.road),
    Tile(4, 2, TileColors.stair),
    Tile(4, 2, TileColors.stair),
    Tile(4, 2, TileColors.room, txt: 'R709'),
    Tile(4, 12, TileColors.empty),
    Tile(2, 4, TileColors.room, txt: 'R725'),
    Tile(4, 2, TileColors.room, txt: 'R755'),
    Tile(8, 1, TileColors.road),
    Tile(4, 4, TileColors.room2),
    Tile(8, 4, TileColors.empty),
    Tile(4, 2, TileColors.room, txt: 'R754'),
    Tile(2, 4, TileColors.room, txt: 'R724'),
    Tile(4, 2, TileColors.room, txt: 'R753'),
    Tile(4, 2, TileColors.room, txt: 'R706'),
    Tile(2, 2, TileColors.room2),
    Tile(2, 2, TileColors.room2),
    Tile(9, 6, TileColors.room2),
    Tile(4, 2, TileColors.room, txt: 'R705'),
    Tile(2, 4, TileColors.room, txt: 'R723'),
    Tile(4, 4, TileColors.room, txt: 'R731'),
    Tile(4, 2, TileColors.room, txt: 'R704'),
    Tile(4, 2, TileColors.stair),
    Tile(6, 4, TileColors.empty),
    Tile(30, 2, TileColors.road),
    Tile(5, 10, TileColors.room, txt: 'R791'),
    Tile(4, 2, TileColors.road),
    Tile(3, 4, TileColors.empty),
    Tile(1, 7, TileColors.road),
    Tile(1, 2, TileColors.ev),
    Tile(3, 2, TileColors.stair),
    Tile(1, 2, TileColors.room2),
    Tile(4, 2, TileColors.room, txt: 'R751'),
    Tile(5, 2, TileColors.room2),
    Tile(4, 8, TileColors.room, txt: 'R781'),
    Tile(4, 8, TileColors.room, txt: 'R782'),
    Tile(2, 2, TileColors.ev),
    Tile(2, 2, TileColors.road),
    Tile(4, 2, TileColors.room, txt: 'R703'),
    Tile(6, 1, TileColors.road),
    Tile(5, 4, TileColors.empty),
    Tile(9, 6, TileColors.empty),
    Tile(4, 2, TileColors.road),
    Tile(3, 5, TileColors.empty),
    Tile(2, 5, TileColors.room2),
    Tile(3, 3, TileColors.empty),
    Tile(4, 2, TileColors.room, txt: 'R702'),
    Tile(3, 2, TileColors.toilet),
    Tile(1, 2, TileColors.stair),
    Tile(1, 2, TileColors.road),
    Tile(2, 2, TileColors.toilet),
    Tile(4, 2, TileColors.room, txt: 'R701'),
    Tile(1, 2, TileColors.room2),
    Tile(2, 2, TileColors.empty),
    Tile(3, 2, TileColors.toilet),
    Tile(5, 2, TileColors.room2),
    Tile(2, 2, TileColors.toilet),
    Tile(2, 2, TileColors.toilet),
    Tile(1, 1, TileColors.toilet),
  ];

  static final List<Tile> map01TileList = [
    Tile(40, 7, TileColors.empty),
    Tile(8, 7, TileColors.room2),
    Tile(40, 1, TileColors.road),
    Tile(2, 7, TileColors.stair),
    Tile(6, 4, TileColors.room2),
    Tile(1, 6, TileColors.road),
    Tile(1, 6, TileColors.room2),
    Tile(10, 2, TileColors.room2),
    Tile(1, 6, TileColors.road),
    Tile(3, 6, TileColors.toilet), //toilet
    Tile(2, 6, TileColors.stair),
    Tile(16, 2, TileColors.room2),
    Tile(2, 2, TileColors.room2),
    Tile(1, 6, TileColors.road),
    Tile(3, 2, TileColors.toilet),
    Tile(2, 4, TileColors.room), //135
    Tile(2, 4, TileColors.room), //134
    Tile(2, 4, TileColors.room), //133
    Tile(2, 4, TileColors.room), //132
    Tile(2, 4, TileColors.room), //131
    Tile(2, 4, TileColors.room), //130
    Tile(2, 4, TileColors.room), //129
    Tile(2, 4, TileColors.room), //128
    Tile(2, 4, TileColors.room), //127
    Tile(2, 4, TileColors.room), //126
    Tile(2, 4, TileColors.room), //125
    Tile(2, 4, TileColors.room), //124
    Tile(2, 4, TileColors.room), //123
    Tile(2, 4, TileColors.room), //122
    Tile(1, 4, TileColors.room2),
    Tile(2, 4, TileColors.room), //121
    Tile(4, 3, TileColors.room2),
    Tile(2, 3, TileColors.room2),
    Tile(42, 1, TileColors.road),
    Tile(6, 13, TileColors.room), //食堂
    Tile(12, 5, TileColors.room2),
    Tile(6, 12, TileColors.road),
    Tile(18, 5, TileColors.room2),
    Tile(6, 1, TileColors.road),
    Tile(2, 2, TileColors.road),
    Tile(2, 2, TileColors.ev), //ev
    Tile(2, 2, TileColors.road),
    Tile(6, 9, TileColors.road),
    Tile(12, 7, TileColors.room2), //アトリエ
    Tile(18, 7, TileColors.road),
  ];

  static List<Tile> map02TileList = [
    Tile(40, 1, TileColors.road),
    Tile(2, 3, TileColors.room2),
    Tile(6, 7, TileColors.room2),
    Tile(1, 6, TileColors.road),
    Tile(3, 2, TileColors.room2),
    Tile(2, 2, TileColors.room2),
    Tile(6, 2, TileColors.room2),
    Tile(1, 6, TileColors.road),
    Tile(3, 6, TileColors.toilet),
    Tile(2, 2, TileColors.room2),
    Tile(6, 2, TileColors.room2),
    Tile(6, 2, TileColors.room2),
    Tile(4, 2, TileColors.room2),
    Tile(2, 2, TileColors.toilet),
    Tile(1, 6, TileColors.road),
    Tile(3, 2, TileColors.toilet),
    Tile(1, 4, TileColors.room2),
    Tile(2, 4, TileColors.room), //235
    Tile(2, 4, TileColors.room), //234
    Tile(2, 4, TileColors.room), //233
    Tile(2, 4, TileColors.room), //232
    Tile(2, 4, TileColors.room), //231
    Tile(2, 4, TileColors.stair),
    Tile(2, 4, TileColors.room), //230
    Tile(2, 4, TileColors.room), //229
    Tile(2, 4, TileColors.room), //228
    Tile(2, 4, TileColors.room), //227
    Tile(2, 4, TileColors.room), //226
    Tile(2, 4, TileColors.room), //225
    Tile(2, 4, TileColors.room), //224
    Tile(2, 4, TileColors.room), //223
    Tile(2, 4, TileColors.room), //222
    Tile(1, 4, TileColors.room2),
    Tile(2, 4, TileColors.room), //221
    Tile(2, 4, TileColors.stair),
    Tile(42, 1, TileColors.road),
    Tile(6, 6, TileColors.room), //売店
    Tile(12, 5, TileColors.room2),
    Tile(4, 5, TileColors.road),
    Tile(2, 5, TileColors.stair),
    Tile(18, 2, TileColors.room2),
    Tile(6, 1, TileColors.road),
    Tile(4, 4, TileColors.road),
    Tile(2, 4, TileColors.stair),
    Tile(18, 3, TileColors.road),
    Tile(36, 3, TileColors.empty), //empty
    Tile(2, 6, TileColors.road),
    Tile(2, 2, TileColors.ev), //ev
  ];

  static final List<Tile> map03TileList = [
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
    Tile(2, 12, TileColors.road, left: 1.5, right: 1.5),
    Tile(4, 8, TileColors.empty),
    Tile(2, 2, TileColors.ev), // エレベーター
    Tile(2, 2, TileColors.empty),
    Tile(2, 1, TileColors.road),
  ];
}
