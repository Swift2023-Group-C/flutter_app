import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_app/components/map_controller.dart';

enum TileType {
  classroom,
  teacherroom,
  subroom,
  otherroom,
  wc,
  stair,
  ev,
  road,
  empty,
}

abstract final class TileColors {
  static Color get room => Colors.grey.shade700;
  static Color get room2 => Colors.grey.shade500;
  static Color get road => Colors.grey.shade300;
  static Color get toilet => Colors.red.shade200;
  //static Color get stair => Colors.blueGrey.shade600;
  static Color get stair => Colors.grey.shade300;
  static Color get ev => Colors.grey.shade800;
  static Color get using => Colors.yellow.shade500;
  static const Color empty = Colors.transparent;
}

abstract final class MapColors {
  static Color get wcMan => Colors.blue.shade800;
  static Color get wcWoman => Colors.red.shade800;
}

class StairType {
  final Axis direction;
  final bool up;
  final bool down;
  const StairType(this.direction, this.up, this.down);
  Axis getDirection() {
    return direction;
  }
}

// ignore: must_be_immutable
class Tile extends StatelessWidget {
  final int width;
  final int height;
  final TileType ttype;
  final double top;
  final double right;
  final double bottom;
  final double left;
  final String txt;
  final String? classroomNo;
  List<String>? lessonIds;
  final int wc; // 0x Man: 1000, Woman: 0100, WheelChair: 0010, Kettle: 0001
  bool using;
  double fontSize;
  late Color tileColor;
  final StairType stairType;

  Tile(
    this.width,
    this.height,
    this.ttype, {
    Key? key,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
    this.txt = '',
    this.classroomNo,
    this.lessonIds,
    this.wc = 0x0000,
    this.using = false,
    this.fontSize = 4,
    this.stairType = const StairType(Axis.horizontal, true, true),
  }) : super(key: key) {
    switch (ttype) {
      case TileType.classroom:
        tileColor = TileColors.room;
        break;
      case TileType.teacherroom:
        tileColor = TileColors.room;
        break;
      case TileType.subroom:
        tileColor = TileColors.room;
        break;
      case TileType.otherroom:
        tileColor = TileColors.room2;
        break;
      case TileType.wc:
        tileColor = TileColors.toilet;
        break;
      case TileType.stair:
        tileColor = TileColors.stair;
        break;
      case TileType.ev:
        tileColor = TileColors.ev;
        break;
      case TileType.road:
        tileColor = TileColors.road;
        break;
      default:
        tileColor = TileColors.empty;
    }
    if (width == 1) {
      fontSize = 3;
    }
  }
  StaggeredTile staggeredTile() {
    return StaggeredTile.count(width, height.toDouble());
  }

  void setUsing(bool u) {
    using = u;
  }

  void setLessonIds(List<String> lIds) {
    lessonIds = lIds;
  }

  Widget stackTextIcon() {
    if (wc > 0) {
      List<Icon> icons = [];
      if (wc & 0x1000 > 0) {
        icons.add(Icon(
          Icons.man,
          color: MapColors.wcMan,
          size: 10,
        ));
      }
      if (wc & 0x0100 > 0) {
        icons.add(Icon(
          Icons.woman,
          color: MapColors.wcWoman,
          size: 10,
        ));
      }
      if (wc & 0x0010 > 0) {
        icons.add(const Icon(
          Icons.accessible,
          size: 10,
        ));
      }
      if (wc & 0x0001 > 0) {
        icons.add(const Icon(
          Icons.coffee_outlined,
          size: 10,
        ));
      }
      return Wrap(
        children: icons,
      );
    }
    if (ttype == TileType.ev) {
      return const Icon(
        Icons.elevator_outlined,
        size: 12,
        color: Colors.white,
        weight: 100,
      );
    }
    if (ttype == TileType.stair) {
      return SizedBox.expand(
        child: Flex(
          direction: stairType.getDirection(),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (stairType.direction == Axis.horizontal)
              for (int i = 0; i < (width * 2.5).toInt(); i++) ...{
                const Expanded(
                    child: VerticalDivider(
                  thickness: 0.3,
                  color: Colors.black,
                )),
              }
            else
              for (int i = 0; i < (height * 2.5).toInt(); i++) ...{
                const Expanded(
                    child: Divider(
                  thickness: 0.3,
                  color: Colors.black,
                )),
              }
          ],
        ),
      );
    }

    return Text(
      txt,
      style: TextStyle(
          color: (tileColor == TileColors.room) ? Colors.white : Colors.black,
          fontSize: fontSize),
    );
  }

  BorderSide oneBorderSide(double n) {
    if (n > 0) {
      return BorderSide(width: n, color: Colors.black);
    } else {
      return BorderSide.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(SizedBox.expand(
        child: Container(
            padding: EdgeInsets.only(
              top: (top > 0) ? 0 : 1,
              right: (right > 0) ? 0 : 1,
              bottom: (bottom > 0) ? 0 : 1,
              left: (left > 0) ? 0 : 1,
            ),
            decoration: BoxDecoration(
              border: Border(
                  top: oneBorderSide(top),
                  right: oneBorderSide(right),
                  bottom: oneBorderSide(bottom),
                  left: oneBorderSide(left)),
              color:
                  (tileColor == TileColors.empty) ? tileColor : TileColors.road,
            ),
            child: SizedBox.expand(
              child: Container(
                padding: const EdgeInsets.all(0),
                color: tileColor,
              ),
            ))));
    widgetList.add(stackTextIcon());
    if (ttype == TileType.stair) {
      if (stairType.up && !stairType.down) {
        widgetList.add(SizedBox.expand(
            child: Center(
          child: Icon(
            Icons.arrow_upward_rounded,
            size: 12,
            color: Colors.grey.shade700,
          ),
        )));
      } else if (!stairType.up && stairType.down) {
        widgetList.add(SizedBox.expand(
            child: Center(
          child: Icon(
            Icons.arrow_downward_rounded,
            size: 12,
            color: Colors.grey.shade700,
          ),
        )));
      } else if (stairType.up && stairType.down) {
        if (stairType.direction == Axis.horizontal) {
          widgetList.add(const SizedBox.expand(
            child: Divider(
              thickness: 0.3,
              color: Colors.black,
            ),
          ));
        } else {
          widgetList.add(const SizedBox.expand(
            child: VerticalDivider(
              thickness: 0.3,
              color: Colors.black,
            ),
          ));
        }
      }
    }
    return Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.loose,
        children: widgetList);
  }
}

abstract final class GridMaps {
  static final Map<String, List<Tile>> mapTileListMap = {
    "1": [
      Tile(48, 36, TileType.empty),
      Tile(40, 7, TileType.empty),
      Tile(8, 7, TileType.otherroom),
      Tile(40, 1, TileType.road),
      Tile(2, 7, TileType.stair,
          stairType: const StairType(Axis.vertical, true, false)),
      Tile(6, 4, TileType.otherroom),
      Tile(1, 6, TileType.road),
      Tile(1, 6, TileType.otherroom),
      Tile(10, 2, TileType.otherroom),
      Tile(1, 6, TileType.road),
      Tile(3, 6, TileType.wc, wc: 0x1101), // アトリエ側トイレ
      Tile(2, 6, TileType.stair,
          stairType: const StairType(Axis.vertical, true, false)),
      Tile(16, 2, TileType.otherroom),
      Tile(2, 2, TileType.wc, wc: 0x0100), // 食堂側トイレ
      Tile(1, 6, TileType.road),
      Tile(3, 2, TileType.wc, wc: 0x1010), // 食堂側トイレ
      Tile(2, 4, TileType.classroom), //135
      Tile(2, 4, TileType.classroom), //134
      Tile(2, 4, TileType.classroom), //133
      Tile(2, 4, TileType.classroom), //132
      Tile(2, 4, TileType.classroom), //131
      Tile(2, 4, TileType.classroom), //130
      Tile(2, 4, TileType.classroom), //129
      Tile(2, 4, TileType.classroom), //128
      Tile(2, 4, TileType.classroom), //127
      Tile(2, 4, TileType.classroom), //126
      Tile(2, 4, TileType.classroom), //125
      Tile(2, 4, TileType.classroom), //124
      Tile(2, 4, TileType.classroom), //123
      Tile(2, 4, TileType.classroom), //122
      Tile(1, 4, TileType.otherroom),
      Tile(2, 4, TileType.classroom), //121
      Tile(4, 3, TileType.otherroom),
      Tile(2, 3, TileType.otherroom),
      Tile(42, 1, TileType.road),
      Tile(6, 13, TileType.classroom), //食堂
      Tile(12, 5, TileType.otherroom),
      Tile(6, 12, TileType.road),
      Tile(18, 2, TileType.otherroom, right: 1, left: 1),
      Tile(6, 1, TileType.road),
      Tile(2, 2, TileType.road),
      Tile(2, 2, TileType.ev), //ev
      Tile(2, 2, TileType.road),
      Tile(18, 2, TileType.road, right: 1, left: 1),
      Tile(6, 9, TileType.road),
      Tile(18, 2, TileType.road),
      Tile(12, 7, TileType.otherroom, classroomNo: '50', txt: 'アトリエ'), //アトリエ
      Tile(18, 6, TileType.road, left: 1, right: 1),
    ],
    "2": [
      Tile(48, 37, TileType.empty),
      Tile(40, 1, TileType.road),
      Tile(2, 3, TileType.otherroom),
      Tile(6, 7, TileType.otherroom),
      Tile(1, 6, TileType.road),
      Tile(3, 2, TileType.otherroom),
      Tile(2, 2, TileType.otherroom),
      Tile(6, 2, TileType.otherroom),
      Tile(1, 6, TileType.road),
      Tile(3, 6, TileType.wc, wc: 0x1101), // アトリエ側トイレ
      Tile(2, 2, TileType.otherroom),
      Tile(6, 2, TileType.otherroom),
      Tile(6, 2, TileType.otherroom),
      Tile(4, 2, TileType.otherroom),
      Tile(2, 2, TileType.wc, wc: 0x0100), // 購買側トイレ
      Tile(1, 6, TileType.road),
      Tile(3, 2, TileType.wc, wc: 0x1010), // 購買側トイレ
      Tile(1, 4, TileType.otherroom),
      Tile(2, 4, TileType.classroom), //235
      Tile(2, 4, TileType.classroom), //234
      Tile(2, 4, TileType.classroom), //233
      Tile(2, 4, TileType.classroom), //232
      Tile(2, 4, TileType.classroom), //231
      Tile(2, 4, TileType.stair,
          stairType: const StairType(Axis.vertical, true, false)), // アトリエ側階段
      Tile(2, 4, TileType.classroom), //230
      Tile(2, 4, TileType.classroom), //229
      Tile(2, 4, TileType.classroom), //228
      Tile(2, 4, TileType.classroom), //227
      Tile(2, 4, TileType.classroom), //226
      Tile(2, 4, TileType.classroom), //225
      Tile(2, 4, TileType.classroom), //224
      Tile(2, 4, TileType.classroom), //223
      Tile(2, 4, TileType.classroom), //222
      Tile(1, 4, TileType.otherroom),
      Tile(2, 4, TileType.classroom), //221
      Tile(2, 4, TileType.stair,
          stairType: const StairType(Axis.vertical, true, false)), // 購買側階段
      Tile(42, 1, TileType.road),
      Tile(6, 6, TileType.classroom), //売店
      Tile(12, 5, TileType.otherroom),
      Tile(4, 5, TileType.road),
      Tile(2, 5, TileType.stair,
          stairType: const StairType(Axis.vertical, false, true)),
      Tile(18, 2, TileType.otherroom),
      Tile(6, 1, TileType.road),
      Tile(4, 4, TileType.road),
      Tile(2, 4, TileType.stair,
          stairType: const StairType(Axis.vertical, false, true)),
      Tile(18, 3, TileType.road),
      Tile(36, 6, TileType.empty), //empty
      Tile(2, 6, TileType.road),
      Tile(10, 2, TileType.empty),
      Tile(2, 2, TileType.ev), //ev
    ],
    "3": [
      Tile(12, 18, TileType.classroom,
          txt: '体育館', top: 1, left: 1, classroomNo: '51'),
      Tile(6, 6, TileType.road, top: 1),
      Tile(30, 6, TileType.empty, left: 1),
      Tile(4, 4, TileType.wc, wc: 0x1110), // 体育館トイレ
      Tile(2, 4, TileType.road),
      Tile(6, 12, TileType.classroom, txt: '工房', top: 1),
      Tile(6, 12, TileType.classroom, txt: 'エレクトロニクス工房', top: 1),
      Tile(6, 2, TileType.classroom, txt: '医務室', top: 1),
      Tile(2, 12, TileType.road, top: 1),
      Tile(6, 2, TileType.otherroom, top: 1),
      Tile(4, 3, TileType.otherroom, top: 1, right: 1),
      Tile(6, 4, TileType.classroom, txt: '音響スタジオ'),
      Tile(6, 1, TileType.road),
      Tile(10, 2, TileType.otherroom, right: 1),
      Tile(1, 2, TileType.otherroom),
      Tile(1, 2, TileType.road),
      Tile(2, 2, TileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, true, false)), // 体育館側階段
      Tile(2, 2, TileType.road),
      Tile(2, 7, TileType.wc, wc: 0x1100), // 駐車場側トイレ
      Tile(2, 7, TileType.stair,
          top: 1,
          left: 1,
          right: 1,
          stairType: const StairType(Axis.vertical, true, false)), // 事務局行き階段
      Tile(6, 7, TileType.classroom, txt: 'ミュージアム', right: 1),
      Tile(6, 2, TileType.road),
      Tile(6, 6, TileType.classroom),
      Tile(4, 4, TileType.otherroom),
      Tile(2, 4, TileType.road),
      Tile(48, 2, TileType.road, left: 1, right: 1), // モール
      Tile(14, 2, TileType.road, left: 1),
      Tile(2, 2, TileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType:
              const StairType(Axis.horizontal, true, false)), // モール体育館側階段
      Tile(18, 2, TileType.road),
      Tile(2, 2, TileType.ev, top: 1, left: 1, bottom: 1), // モールエレベーター
      Tile(2, 2, TileType.road),
      Tile(2, 2, TileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, true, false)), // モール入口側階段
      Tile(8, 2, TileType.road, right: 1),
      Tile(48, 2, TileType.road, left: 1, right: 1), // モール
      Tile(12, 7, TileType.classroom, txt: '大講義室', left: 1, classroomNo: '2'),
      Tile(1, 7, TileType.otherroom),
      Tile(3, 5, TileType.otherroom),
      Tile(2, 7, TileType.road),
      Tile(6, 7, TileType.classroom, txt: '365', classroomNo: '18'),
      Tile(6, 7, TileType.classroom, txt: '364', classroomNo: '17'),
      Tile(6, 7, TileType.classroom, txt: '363', classroomNo: '16'),
      Tile(4, 2, TileType.otherroom),
      Tile(2, 7, TileType.road),
      Tile(6, 37, TileType.classroom,
          txt: 'Library', right: 1, bottom: 1, left: 1),
      Tile(2, 5, TileType.wc, wc: 0x1000), // 入口側トイレ男
      Tile(2, 5, TileType.otherroom),
      Tile(3, 2, TileType.otherroom),
      Tile(42, 1, TileType.road, left: 1),
      Tile(1, 6, TileType.road, left: 1),
      Tile(5, 2, TileType.otherroom),
      Tile(6, 2, TileType.classroom),
      Tile(4, 4, TileType.wc, wc: 0x1101), // 331側トイレ
      Tile(2, 6, TileType.road),
      Tile(6, 2, TileType.classroom),
      Tile(6, 2, TileType.classroom),
      Tile(4, 2, TileType.classroom),
      Tile(2, 2, TileType.classroom),
      Tile(4, 2, TileType.wc, wc: 0x0110), // 入口側トイレ女
      Tile(2, 6, TileType.road),
      Tile(1, 4, TileType.classroom),
      Tile(2, 4, TileType.classroom, txt: '335'),
      Tile(2, 4, TileType.classroom, txt: '334'),
      Tile(2, 4, TileType.classroom, txt: '333'),
      Tile(2, 4, TileType.classroom, txt: '332'),
      Tile(2, 4, TileType.classroom, txt: '331'),
      Tile(2, 4, TileType.classroom, txt: '330'),
      Tile(2, 4, TileType.classroom, txt: '329'),
      Tile(2, 4, TileType.classroom, txt: '328'),
      Tile(2, 4, TileType.classroom, txt: '327'),
      Tile(2, 4, TileType.classroom, txt: '326'),
      Tile(2, 4, TileType.classroom, txt: '325'),
      Tile(2, 4, TileType.classroom, txt: '324'),
      Tile(2, 4, TileType.classroom, txt: '323'),
      Tile(2, 4, TileType.classroom, txt: '322'),
      Tile(2, 4, TileType.classroom, txt: '321'),
      Tile(4, 2, TileType.classroom),
      Tile(2, 4, TileType.classroom),
      Tile(42, 1, TileType.road, left: 1),
      Tile(12, 5, TileType.otherroom, left: 1, bottom: 1),
      Tile(4, 3, TileType.road),
      Tile(2, 5, TileType.stair,
          bottom: 1,
          left: 1,
          right: 1,
          stairType: const StairType(Axis.vertical, false, true)), // 階段331側下り
      Tile(2, 2, TileType.otherroom),
      Tile(1, 2, TileType.road),
      Tile(14, 2, TileType.otherroom),
      Tile(1, 2, TileType.road),
      Tile(4, 3, TileType.road),
      Tile(2, 5, TileType.stair,
          bottom: 1,
          left: 1,
          right: 1,
          stairType: const StairType(Axis.vertical, false, true)), // 階段321側下り
      Tile(18, 3, TileType.road, bottom: 1),
      Tile(2, 2, TileType.road, bottom: 1),
      Tile(2, 2, TileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, true, false)), // 階段331側上り
      Tile(2, 2, TileType.road),
      Tile(2, 2, TileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, true, false)), // 階段321側上り
      Tile(36, 12, TileType.empty, right: 1),
      Tile(2, 12, TileType.road, bottom: 1),
      Tile(4, 8, TileType.empty, left: 1),
      Tile(2, 2, TileType.ev, left: 1, top: 1, right: 1), // エレベーター
      Tile(2, 2, TileType.empty),
      Tile(2, 1, TileType.road, right: 1, bottom: 1),
      Tile(2, 1, TileType.empty),
      Tile(4, 1, TileType.empty, left: 1),
    ],
    "4": [
      Tile(12, 18, TileType.otherroom,
          txt: 'Gym', top: 1, left: 1, bottom: 1, right: 1),
      //Tile(6, 6, TileType.empty, left: 1.5),  一応吹き抜けでトレーニングルーム見える
      Tile(36, 6, TileType.empty),
      Tile(2, 6, TileType.road, top: 1),
      Tile(2, 4, TileType.wc, top: 1, right: 1, wc: 0x1110), // 体育館側トイレ
      Tile(2, 6, TileType.empty, bottom: 1),
      Tile(6, 6, TileType.classroom,
          txt: '495C&D', classroomNo: '9', top: 1, left: 1),
      Tile(6, 6, TileType.classroom, txt: '494C&D', classroomNo: '8', top: 1),
      Tile(6, 6, TileType.classroom, txt: '493', classroomNo: '3', top: 1),
      Tile(2, 6, TileType.road, top: 1),
      Tile(2, 6, TileType.road, top: 1, bottom: 1),
      Tile(2, 6, TileType.road, top: 1),
      Tile(6, 10, TileType.classroom, txt: '事務局', top: 1, right: 1),
      Tile(2, 2, TileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, true, true)), // 体育館側階段
      Tile(30, 1, TileType.road),
      Tile(2, 13, TileType.road),
      Tile(2, 5, TileType.otherroom, right: 1, bottom: 1),
      Tile(2, 5, TileType.empty, top: 1),
      Tile(6, 5, TileType.classroom, txt: '485', left: 1, bottom: 1),
      Tile(6, 5, TileType.classroom, txt: '484', classroomNo: '10', bottom: 1),
      Tile(6, 5, TileType.classroom, txt: '483', classroomNo: '19', bottom: 1),
      Tile(2, 13, TileType.road),
      Tile(2, 5, TileType.wc, bottom: 1, wc: 0x1110), // 事務側トイレ
      Tile(2, 5, TileType.stair,
          right: 1,
          bottom: 1,
          left: 1,
          stairType: const StairType(Axis.vertical, false, true)),
      Tile(1, 2, TileType.road),
      Tile(5, 2, TileType.classroom, txt: '局長室', right: 1, bottom: 1),
      Tile(12, 6, TileType.empty, right: 1),
      Tile(22, 2, TileType.empty, left: 1, right: 1),
      Tile(4, 2, TileType.empty, left: 1, right: 1),
      Tile(1, 8, TileType.road),
      Tile(5, 6, TileType.empty, left: 1),
      Tile(2, 2, TileType.stair, top: 1, right: 1, bottom: 1), // モール体育館側
      Tile(18, 2, TileType.empty),
      Tile(2, 2, TileType.ev, txt: 'ev', top: 1, bottom: 1, left: 1),
      Tile(2, 2, TileType.stair, top: 1, right: 1, bottom: 1), // モール正面玄関側
      Tile(2, 2, TileType.empty, right: 1),
      Tile(22, 2, TileType.empty, left: 1, right: 1),
      Tile(4, 2, TileType.empty, left: 1, right: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-15', top: 1, left: 1), //文字はみ出してる
      Tile(2, 2, TileType.otherroom, txt: 'S-14', top: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-13', top: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-12', top: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-11', top: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-10', top: 1),
      Tile(1, 2, TileType.otherroom, top: 1),
      Tile(1, 2, TileType.wc, wc: 0x0001, top: 1, right: 1),
      Tile(2, 2, TileType.empty, bottom: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-9', top: 1, left: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-8', top: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-7', top: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-6', top: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-5', top: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-4', top: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-3', top: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-2', top: 1),
      Tile(2, 2, TileType.otherroom, txt: 'S-1', top: 1),
      Tile(1, 2, TileType.otherroom, top: 1),
      Tile(1, 2, TileType.otherroom, txt: '倉庫', top: 1, right: 1),
      Tile(2, 2, TileType.empty, bottom: 1, right: 1),
      Tile(2, 2, TileType.otherroom, top: 1),
      Tile(3, 3, TileType.otherroom, txt: '理事室', top: 1, right: 1),
      Tile(43, 1, TileType.road, left: 1),
      Tile(2, 5, TileType.otherroom, txt: '秘書室'),
      Tile(1, 4, TileType.road, left: 1),
      Tile(1, 4, TileType.otherroom, txt: '倉庫'),
      Tile(2, 4, TileType.otherroom, txt: '435'),
      Tile(2, 4, TileType.otherroom, txt: '434'),
      Tile(2, 4, TileType.otherroom, txt: '433'),
      Tile(2, 4, TileType.otherroom, txt: '432'),
      Tile(2, 4, TileType.otherroom, txt: '431'),
      Tile(2, 4, TileType.road),
      Tile(2, 3, TileType.wc, wc: 0x1100),
      Tile(2, 10, TileType.otherroom, bottom: 1),
      Tile(1, 2, TileType.otherroom, txt: '印刷'),
      Tile(1, 4, TileType.road),
      Tile(2, 4, TileType.otherroom, txt: '429'),
      Tile(2, 4, TileType.otherroom, txt: '428'),
      Tile(2, 4, TileType.otherroom, txt: '427'),
      Tile(2, 4, TileType.otherroom, txt: '426'),
      Tile(2, 4, TileType.otherroom, txt: '425'),
      Tile(2, 4, TileType.otherroom, txt: '424'),
      Tile(2, 4, TileType.otherroom, txt: '423'),
      Tile(2, 4, TileType.otherroom, txt: '422'),
      Tile(2, 4, TileType.road),
      Tile(2, 3, TileType.wc, wc: 0x1100, right: 1),
      Tile(2, 10, TileType.empty, top: 1, right: 1),
      Tile(1, 9, TileType.road),
      Tile(3, 4, TileType.otherroom, txt: '学長室', right: 1),
      Tile(1, 2, TileType.otherroom, txt: '倉庫'),
      Tile(2, 1, TileType.otherroom),
      Tile(2, 1, TileType.otherroom, right: 1),
      Tile(14, 1, TileType.road, left: 1),
      Tile(2, 3, TileType.otherroom, txt: 'M402'),
      Tile(22, 1, TileType.road, right: 1),
      Tile(5, 4, TileType.otherroom, txt: '特別応接室', right: 1),
      Tile(12, 5, TileType.otherroom, left: 1, bottom: 1),
      Tile(2, 5, TileType.road),
      Tile(18, 3, TileType.otherroom),
      Tile(2, 5, TileType.road),
      Tile(2, 5, TileType.road, txt: 'ラウンジ', right: 1, bottom: 1),
      Tile(2, 3, TileType.otherroom, txt: 'M401', bottom: 1),
      Tile(6, 2, TileType.otherroom, bottom: 1),
      Tile(6, 2, TileType.classroom, txt: 'メタ学習ラボ', bottom: 1),
      Tile(6, 2, TileType.otherroom, bottom: 1),
      Tile(4, 1, TileType.otherroom),
      Tile(1, 1, TileType.road, right: 1),
      Tile(6, 1, TileType.road, right: 1),
      Tile(12, 19, TileType.empty, right: 1),
      Tile(2, 7, TileType.road),
      Tile(22, 5, TileType.empty, left: 1, right: 1),
      Tile(2, 7, TileType.road),
      Tile(4, 5, TileType.empty, left: 1, right: 1),
      Tile(1, 7, TileType.road),
      Tile(3, 3, TileType.otherroom, txt: 'サーバーコンピュータ事務室'),
      Tile(2, 3, TileType.wc, wc: 0x1101, right: 1), // サーバーコンピュータ室側トイレ
      Tile(5, 4, TileType.otherroom, txt: 'サーバーコンピュータ室', right: 1),
      Tile(2, 2, TileType.stair, top: 1, right: 1, bottom: 1),
      Tile(20, 2, TileType.empty, bottom: 1, right: 1),
      Tile(2, 2, TileType.stair, top: 1, right: 1, bottom: 1),
      Tile(2, 2, TileType.empty, right: 1),
      Tile(26, 1, TileType.road),
      Tile(4, 8, TileType.empty, left: 1, right: 1),
      Tile(6, 12, TileType.classroom,
          txt: '講堂', classroomNo: '1', top: 1, right: 1, bottom: 1),
      Tile(2, 11, TileType.road, bottom: 1),
      Tile(4, 11, TileType.classroom, txt: 'デルタ', right: 1, bottom: 1),
      Tile(18, 11, TileType.empty, top: 1, right: 1),
      Tile(2, 9, TileType.road),
      Tile(2, 2, TileType.ev, txt: 'ev', left: 1, top: 1, right: 1),
      Tile(2, 2, TileType.empty, right: 1, bottom: 1),
      Tile(6, 2, TileType.road, bottom: 1)
    ],
    "5": [
      Tile(16, 2, TileType.otherroom, top: 1, left: 1, right: 1), //サークル1
      Tile(32, 6, TileType.empty), //empty
      Tile(14, 1, TileType.road, left: 1),
      Tile(2, 8, TileType.otherroom, right: 1), //サークル3
      Tile(1, 14, TileType.road, left: 1),
      Tile(11, 14, TileType.empty,
          top: 1, right: 1, bottom: 1, left: 1), //empty gym
      Tile(2, 9, TileType.road),
      Tile(2, 6, TileType.empty, bottom: 1), //empty
      Tile(6, 6, TileType.classroom,
          txt: '595', classroomNo: '6', top: 1, left: 1),
      Tile(6, 6, TileType.classroom, txt: '594', classroomNo: '5', top: 1),
      Tile(6, 6, TileType.classroom,
          txt: '593', classroomNo: '4', top: 1, right: 1),
      Tile(6, 6, TileType.empty, bottom: 1, right: 1), //吹き抜け
      Tile(6, 12, TileType.otherroom, top: 1, right: 1, bottom: 1),
      Tile(2, 2, TileType.stair,
          stairType: const StairType(Axis.horizontal, false, true),
          top: 1,
          right: 1,
          bottom: 1), // 階段体育館側
      Tile(30, 1, TileType.road),
      Tile(2, 4, TileType.road),
      Tile(2, 5, TileType.wc, wc: 0x1110, right: 1, bottom: 1), // 体育館側トイレ
      Tile(2, 5, TileType.empty, top: 1), //吹き抜け
      Tile(6, 5, TileType.classroom,
          txt: '585', classroomNo: '13', left: 1, bottom: 1),
      Tile(6, 5, TileType.classroom, txt: '584', classroomNo: '12', bottom: 1),
      Tile(6, 5, TileType.classroom, txt: '583', classroomNo: '11', bottom: 1),
      Tile(2, 5, TileType.road),
      Tile(2, 5, TileType.wc, right: 1, bottom: 1, wc: 0x1100), // 事務側トイレ
      Tile(2, 5, TileType.empty, top: 1, right: 1), //吹き抜け
      Tile(14, 1, TileType.road, left: 1),
      Tile(12, 6, TileType.empty, top: 1, bottom: 1, right: 1), //empty left
      Tile(2, 6, TileType.road),
      Tile(22, 2, TileType.empty, left: 1, right: 1), //empty center1
      Tile(2, 6, TileType.road),
      Tile(10, 2, TileType.empty, left: 1), //empty right1
      Tile(2, 2, TileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType:
              const StairType(Axis.horizontal, false, true)), // 階段center側
      Tile(18, 2, TileType.empty), //empty center2
      Tile(2, 2, TileType.ev, top: 1, left: 1, bottom: 1), // エレベーターcenter
      Tile(2, 2, TileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, false, true)), // 階段right側
      Tile(8, 2, TileType.empty), //empty right2
      Tile(22, 2, TileType.empty, left: 1, right: 1, bottom: 1), //empty center3
      Tile(10, 2, TileType.empty, left: 1), //empty right3
      Tile(38, 1, TileType.road, left: 1),
      Tile(2, 5, TileType.otherroom, top: 1, right: 1),
      Tile(2, 5, TileType.empty, right: 1, bottom: 1), //吹き抜け
      Tile(2, 5, TileType.road, top: 1),
      Tile(4, 8, TileType.otherroom, top: 1, right: 1),
      Tile(2, 4, TileType.classroom, txt: '536', left: 1),
      Tile(2, 4, TileType.classroom, txt: '535'),
      Tile(2, 4, TileType.classroom, txt: '534'),
      Tile(2, 4, TileType.classroom, txt: '533'),
      Tile(2, 4, TileType.classroom, txt: '532'),
      Tile(2, 4, TileType.classroom, txt: '531'),
      Tile(2, 4, TileType.road),
      Tile(2, 4, TileType.otherroom, right: 1),
      Tile(2, 4, TileType.empty, top: 1, bottom: 1), //吹き抜け
      Tile(1, 4, TileType.wc, left: 1, wc: 0x0001),
      Tile(1, 4, TileType.road),
      Tile(2, 4, TileType.classroom, txt: '529'),
      Tile(2, 4, TileType.classroom, txt: '528'),
      Tile(2, 4, TileType.classroom, txt: '527'),
      Tile(2, 4, TileType.classroom, txt: '526'),
      Tile(2, 4, TileType.classroom, txt: '525'),
      Tile(2, 4, TileType.classroom, txt: '524'),
      Tile(2, 4, TileType.classroom, txt: '523'),
      Tile(2, 4, TileType.classroom, txt: '522'),
      Tile(2, 4, TileType.road),
      Tile(44, 1, TileType.road, left: 1),
      Tile(12, 2, TileType.otherroom, left: 1, bottom: 1), //スタジオleft
      Tile(2, 2, TileType.road),
      Tile(2, 2, TileType.otherroom, right: 1, bottom: 1),
      Tile(2, 2, TileType.empty, top: 1), //吹き抜け
      Tile(18, 2, TileType.otherroom, left: 1, bottom: 1), //スタジオcenter
      Tile(2, 11, TileType.road),
      Tile(2, 2, TileType.otherroom, right: 1, bottom: 1),
      Tile(2, 2, TileType.empty, top: 1, right: 1), //吹き抜け
      Tile(2, 4, TileType.road),
      Tile(12, 12, TileType.empty, right: 1), //empty left
      Tile(2, 12, TileType.road, bottom: 1),
      Tile(22, 10, TileType.empty, left: 1, right: 1), //empty center
      Tile(4, 9, TileType.empty, left: 1, right: 1, bottom: 1), //empty right
      Tile(4, 2, TileType.otherroom, right: 1),
      Tile(6, 2, TileType.road, right: 1),
      Tile(1, 5, TileType.road),
      Tile(4, 2, TileType.otherroom),
      Tile(1, 5, TileType.road, right: 1),
      Tile(4, 3, TileType.wc, wc: 0x1110), // 講堂側トイレ
      Tile(12, 1, TileType.road, right: 1),
      Tile(2, 2, TileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType:
              const StairType(Axis.horizontal, false, true)), // 階段center側
      Tile(20, 2, TileType.empty, right: 1), //empty center
      Tile(2, 2, TileType.road),
      Tile(2, 2, TileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, false, true)), // 階段講堂側
      Tile(2, 2, TileType.empty, top: 1, right: 1), //empty 階段横
      Tile(1, 2, TileType.road),
      Tile(4, 2, TileType.otherroom), //調光室
      Tile(1, 2, TileType.road, right: 1),
      Tile(36, 12, TileType.empty, right: 1), //empty big1
      Tile(2, 12, TileType.road, bottom: 1), //empty big1
      Tile(4, 8, TileType.empty, left: 1, right: 1), //empty 講堂１
      Tile(6, 12, TileType.classroom, txt: '講堂', right: 1, bottom: 1),
      Tile(2, 2, TileType.ev, left: 1, top: 1, right: 1), // エレベーター
      Tile(2, 2, TileType.empty, right: 1), //empty ev横
      Tile(2, 1, TileType.road, right: 1, bottom: 1), //ev下
      Tile(2, 1, TileType.empty, right: 1), //empty ev右下
      Tile(4, 1, TileType.empty, left: 1, right: 1), //empty ev下
      Tile(42, 7, TileType.empty), //empty ev横
      Tile(6, 7, TileType.empty), //empty
    ],
    "r1": [],
    "r2": [
      Tile(4, 2, TileType.classroom, txt: 'R711'),
      Tile(1, 30, TileType.road),
      Tile(3, 3, TileType.empty),
      Tile(2, 3, TileType.otherroom),
      Tile(5, 3, TileType.empty),
      Tile(2, 9, TileType.otherroom),
      Tile(4, 9, TileType.empty),
      Tile(1, 14, TileType.road),
      Tile(4, 2, TileType.classroom, txt: 'R757'),
      Tile(22, 20, TileType.empty),
      Tile(4, 2, TileType.classroom, txt: 'R710'),
      Tile(4, 2, TileType.classroom, txt: 'R756'),
      Tile(6, 1, TileType.road),
      Tile(2, 22, TileType.road),
      Tile(2, 6, TileType.empty),
      Tile(4, 2, TileType.road),
      Tile(6, 4, TileType.empty),
      Tile(4, 2, TileType.road),
      Tile(4, 2, TileType.stair),
      Tile(4, 2, TileType.stair),
      Tile(4, 2, TileType.classroom, txt: 'R709'),
      Tile(4, 12, TileType.empty),
      Tile(2, 4, TileType.classroom, txt: 'R725'),
      Tile(4, 2, TileType.classroom, txt: 'R755'),
      Tile(8, 1, TileType.road),
      Tile(4, 4, TileType.otherroom),
      Tile(8, 4, TileType.empty),
      Tile(4, 2, TileType.classroom, txt: 'R754'),
      Tile(2, 4, TileType.classroom, txt: 'R724'),
      Tile(4, 2, TileType.classroom, txt: 'R753'),
      Tile(4, 2, TileType.classroom, txt: 'R706'),
      Tile(2, 2, TileType.otherroom),
      Tile(2, 2, TileType.otherroom),
      Tile(9, 6, TileType.otherroom),
      Tile(4, 2, TileType.classroom, txt: 'R705'),
      Tile(2, 4, TileType.classroom, txt: 'R723'),
      Tile(4, 4, TileType.classroom, txt: 'R731'),
      Tile(4, 2, TileType.classroom, txt: 'R704'),
      Tile(4, 2, TileType.stair),
      Tile(6, 4, TileType.empty),
      Tile(30, 2, TileType.road),
      Tile(5, 10, TileType.classroom, txt: 'R791'),
      Tile(4, 2, TileType.road),
      Tile(3, 4, TileType.empty),
      Tile(1, 7, TileType.road),
      Tile(1, 2, TileType.ev),
      Tile(3, 2, TileType.stair),
      Tile(1, 2, TileType.otherroom),
      Tile(4, 2, TileType.classroom, txt: 'R751'),
      Tile(5, 2, TileType.otherroom),
      Tile(4, 8, TileType.classroom, txt: 'R781', classroomNo: '14'),
      Tile(4, 8, TileType.classroom, txt: 'R782', classroomNo: '15'),
      Tile(2, 2, TileType.ev),
      Tile(2, 2, TileType.road),
      Tile(4, 2, TileType.classroom, txt: 'R703'),
      Tile(6, 1, TileType.road),
      Tile(5, 4, TileType.empty),
      Tile(9, 6, TileType.empty),
      Tile(4, 2, TileType.road),
      Tile(3, 5, TileType.empty),
      Tile(2, 5, TileType.otherroom),
      Tile(3, 3, TileType.empty),
      Tile(4, 2, TileType.classroom, txt: 'R702'),
      Tile(3, 2, TileType.wc),
      Tile(1, 2, TileType.stair),
      Tile(1, 2, TileType.road),
      Tile(2, 2, TileType.wc),
      Tile(4, 2, TileType.classroom, txt: 'R701'),
      Tile(1, 2, TileType.otherroom),
      Tile(2, 2, TileType.empty),
      Tile(3, 2, TileType.wc),
      Tile(5, 2, TileType.otherroom),
      Tile(2, 2, TileType.wc),
      Tile(2, 2, TileType.wc),
      Tile(1, 1, TileType.wc),
    ],
  };
}
