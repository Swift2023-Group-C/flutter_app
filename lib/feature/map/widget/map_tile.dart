import 'package:flutter/material.dart';
import 'package:dotto/app.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

enum TileType {
  classroom, // メインの部屋
  teacherroom, // 教員室と後ろの実験室
  subroom, // メインには使わないけど使う部屋
  otherroom, // 倉庫など
  wc, // トイレ
  stair, // 階段
  ev, // エレベーター
  road, // 道
  empty, // 吹き抜けなど
}

abstract final class TileColors {
  static Color get room => Colors.grey.shade700;
  static Color get teacherRoom => Colors.grey.shade600;
  static Color get subRoom => Colors.grey.shade500;
  static Color get room2 => Colors.grey.shade400;
  static Color get road => Colors.grey.shade300;
  static Color get toilet => Colors.lightGreen.shade400;
  //static Color get stair => Colors.blueGrey.shade600;
  static Color get stair => Colors.grey.shade300;
  static Color get ev => Colors.grey.shade800;
  static Color get using => Colors.orange.shade300;
  static const Color empty = Colors.transparent;
}

abstract final class MapColors {
  static Color get wcMan => Colors.blue.shade800;
  static Color get wcWoman => Colors.red.shade800;
}

// 階段の時の描画設定
class StairType {
  final Axis direction;
  final bool up;
  final bool down;
  const StairType(this.direction, this.up, this.down);
  Axis getDirection() {
    return direction;
  }
}

/// require width, height: Size, require ttype: タイルタイプ enum
///
/// top, right, bottom, left: Borderサイズ, txt
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
  late Color fontColor;
  final StairType stairType;
  DateTime? useEndTime;
  final Widget? innerWidget;

  Tile(
    this.width,
    this.height,
    this.ttype, {
    super.key,
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
    this.useEndTime,
    this.innerWidget,
  }) {
    setColors();
    if (width == 1) {
      fontSize = 3;
    }
    if (txt.length <= 6 && width >= 6) {
      if (txt.length <= 4) {
        fontSize = 8;
      } else {
        fontSize = 6;
      }
    }
  }

  void setColors() {
    switch (ttype) {
      case TileType.classroom:
        tileColor = TileColors.room;
        fontColor = Colors.white;
        break;
      case TileType.teacherroom:
        tileColor = TileColors.teacherRoom;
        fontColor = Colors.white;
        break;
      case TileType.subroom:
        tileColor = TileColors.subRoom;
        fontColor = Colors.black;
        break;
      case TileType.otherroom:
        tileColor = TileColors.room2;
        fontColor = Colors.black;
        break;
      case TileType.wc:
        tileColor = TileColors.toilet;
        fontColor = Colors.black;
        break;
      case TileType.stair:
        tileColor = TileColors.stair;
        fontColor = Colors.black;
        break;
      case TileType.ev:
        tileColor = TileColors.ev;
        fontColor = Colors.black;
        break;
      case TileType.road:
        tileColor = TileColors.road;
        fontColor = Colors.black;
        break;
      default:
        tileColor = TileColors.empty;
        fontColor = Colors.black;
    }
  }

  void setUsing(bool b) {
    using = b;
  }

  void setTileColor(Color c) {
    tileColor = c;
  }

  void setFontColor(Color c) {
    fontColor = c;
  }

  void setUseEndTime(DateTime dt) {
    useEndTime = dt;
  }

  void setLessonIds(List<String> lIds) {
    lessonIds = lIds;
  }

  Widget stackTextIcon() {
    double iconSize = 8;
    int iconLength = (wc & 0x0001) +
        (wc & 0x0010) ~/ 0x0010 +
        (wc & 0x0100) ~/ 0x0100 +
        (wc & 0x1000) ~/ 0x1000;
    if (width == 1) {
      iconSize = 6;
    } else if (width * height / iconLength <= 2) {
      iconSize = 6;
    }
    if (wc > 0) {
      List<Icon> icons = [];
      if (wc & 0x1000 > 0) {
        icons.add(Icon(
          Icons.man,
          color: MapColors.wcMan,
          size: iconSize,
        ));
      }
      if (wc & 0x0100 > 0) {
        icons.add(Icon(
          Icons.woman,
          color: MapColors.wcWoman,
          size: iconSize,
        ));
      }
      if (wc & 0x0010 > 0) {
        icons.add(Icon(
          Icons.accessible,
          size: iconSize,
        ));
      }
      if (wc & 0x0001 > 0) {
        icons.add(Icon(
          Icons.coffee_outlined,
          size: iconSize,
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

    return Consumer(builder: (context, ref, child) {
      final mapUsingMap = ref.watch(mapUsingMapProvider);
      setColors();
      if (classroomNo != null) {
        if (mapUsingMap.containsKey(classroomNo)) {
          if (mapUsingMap[classroomNo]!) {
            fontColor = Colors.black;
          }
        }
      }
      return Text(
        txt,
        style: TextStyle(color: fontColor, fontSize: fontSize),
      );
    });
  }

  BorderSide oneBorderSide(double n, bool focus) {
    if (focus) {
      return const BorderSide(width: 1, color: Colors.red);
    } else if (n > 0) {
      return BorderSide(width: n, color: Colors.black);
    } else {
      return BorderSide.none;
    }
  }

  EdgeInsets edgeInsets(bool focus) {
    return EdgeInsets.only(
      top: (top > 0 || focus) ? 0 : 1,
      right: (right > 0 || focus) ? 0 : 1,
      bottom: (bottom > 0 || focus) ? 0 : 1,
      left: (left > 0 || focus) ? 0 : 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> floorBarString = ['1', '2', '3', '4', '5', 'R6', 'R7'];
    List<Widget> widgetList = [];
    widgetList.add(SizedBox.expand(child: Consumer(
      builder: (context, ref, child) {
        final mapFocusMapDetail = ref.watch(mapFocusMapDetailProvider);
        final mapPage = ref.watch(mapPageProvider);
        final mapUsingMap = ref.watch(mapUsingMapProvider);
        if (classroomNo != null) {
          if (mapUsingMap.containsKey(classroomNo)) {
            if (mapUsingMap[classroomNo]!) {
              using = true;
              tileColor = TileColors.using;
            } else {
              using = false;
              setColors();
            }
          }
        }
        bool focus = false;
        if (mapFocusMapDetail.floor == floorBarString[mapPage]) {
          if (mapFocusMapDetail.roomName == txt) {
            focus = true;
          }
        }
        return Container(
            padding: edgeInsets(focus),
            decoration: BoxDecoration(
              border: Border(
                  top: oneBorderSide(top, focus),
                  right: oneBorderSide(right, focus),
                  bottom: oneBorderSide(bottom, focus),
                  left: oneBorderSide(left, focus)),
              color:
                  (tileColor == TileColors.empty) ? tileColor : TileColors.road,
            ),
            child: SizedBox.expand(
              child: (innerWidget == null)
                  ? Container(
                      padding: const EdgeInsets.all(0),
                      color: focus ? Colors.red : tileColor,
                    )
                  : innerWidget,
            ));
      },
    )));
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
    return Consumer(builder: (context, ref, child) {
      final mapPage = ref.watch(mapPageProvider);
      final mapSearchBarFocusNotifier =
          ref.watch(mapSearchBarFocusProvider.notifier);
      ref.watch(mapUsingMapProvider);
      final mapDetailMap = ref.watch(mapDetailMapProvider);
      if (mapDetailMap.mapDetailList != null) {
        MapDetail? mapDetail =
            mapDetailMap.searchOnce(floorBarString[mapPage], txt);
        if (mapDetail != null) {
          return GestureDetector(
              onTap: () {
                showBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return MapBottomSheet(mapDetail: mapDetail);
                  },
                );
                mapSearchBarFocusNotifier.state.unfocus();
              },
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.loose,
                  children: widgetList));
        }
      }
      return Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.loose,
          children: widgetList);
    });
  }
}

class MapBottomSheet extends StatelessWidget {
  const MapBottomSheet({super.key, required this.mapDetail});
  final MapDetail mapDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        color: Colors.blueGrey.shade100,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectableText(
                    mapDetail.header,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: double.infinity, height: 10),
                  if (mapDetail.detail != null)
                    SelectableText(mapDetail.detail!),
                  if (mapDetail.mail != null)
                    SelectableText('${mapDetail.mail}@fun.ac.jp'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close))),
            ),
          ],
        ));
  }
}

abstract final class GridMaps {
  static final Map<String, List<Tile>> mapTileListMap = {
    "1": [
      Tile(48, 18, TileType.empty),
      Tile(40, 7, TileType.empty),
      Tile(8, 7, TileType.otherroom, left: 1, top: 1, right: 1),
      Tile(40, 1, TileType.road, left: 1, top: 1),
      Tile(2, 3, TileType.otherroom),
      Tile(6, 4, TileType.otherroom, right: 1),
      Tile(1, 6, TileType.road, left: 1),
      Tile(1, 6, TileType.otherroom),
      Tile(2, 2, TileType.teacherroom, txt: '155'),
      Tile(2, 2, TileType.teacherroom, txt: '154'),
      Tile(2, 2, TileType.teacherroom, txt: '153'),
      Tile(2, 2, TileType.teacherroom, txt: '152'),
      Tile(2, 2, TileType.teacherroom, txt: '151'),
      Tile(1, 6, TileType.road),
      Tile(3, 6, TileType.wc, wc: 0x1101), // アトリエ側トイレ
      Tile(2, 2, TileType.otherroom),
      Tile(2, 2, TileType.teacherroom, txt: '150'),
      Tile(2, 2, TileType.teacherroom, txt: '149'),
      Tile(2, 2, TileType.teacherroom, txt: '148'),
      Tile(2, 2, TileType.teacherroom, txt: '147'),
      Tile(2, 2, TileType.teacherroom, txt: '146'),
      Tile(2, 2, TileType.teacherroom, txt: '145'),
      Tile(2, 2, TileType.teacherroom, txt: '144'),
      Tile(2, 2, TileType.teacherroom, txt: '143'),
      Tile(2, 2, TileType.wc, wc: 0x0100), // 食堂側トイレ
      Tile(1, 6, TileType.road),
      Tile(3, 2, TileType.wc, wc: 0x1010), // 食堂側トイレ
      Tile(2, 4, TileType.teacherroom, txt: '135'), //135
      Tile(2, 4, TileType.teacherroom, txt: '134'), //134
      Tile(2, 4, TileType.teacherroom, txt: '133'), //133
      Tile(2, 4, TileType.teacherroom, txt: '132'), //132
      Tile(2, 4, TileType.teacherroom, txt: '131'), //131
      Tile(2, 4, TileType.stair,
          top: 1,
          left: 1,
          right: 1,
          stairType: const StairType(Axis.vertical, true, false)),
      Tile(2, 4, TileType.teacherroom, txt: '130'), //130
      Tile(2, 4, TileType.teacherroom, txt: '129'), //129
      Tile(2, 4, TileType.teacherroom, txt: '128'), //128
      Tile(2, 4, TileType.teacherroom, txt: '127'), //127
      Tile(2, 4, TileType.teacherroom, txt: '126'), //126
      Tile(2, 4, TileType.teacherroom, txt: '125'), //125
      Tile(2, 4, TileType.teacherroom, txt: '124'), //124
      Tile(2, 4, TileType.teacherroom, txt: '123'), //123
      Tile(2, 4, TileType.subroom, txt: '122'), //122
      Tile(1, 4, TileType.otherroom),
      Tile(2, 4, TileType.subroom, txt: '121'), //121
      Tile(2, 4, TileType.stair,
          top: 1,
          left: 1,
          right: 1,
          stairType: const StairType(Axis.vertical, true, false)),
      Tile(6, 16, TileType.subroom, right: 1, bottom: 1, txt: '食堂'), //食堂
      Tile(42, 1, TileType.road, left: 1),
      Tile(12, 6, TileType.otherroom, left: 1),
      Tile(6, 10, TileType.road),
      Tile(18, 3, TileType.otherroom, right: 1, left: 1),
      Tile(6, 1, TileType.road),
      Tile(2, 2, TileType.road),
      Tile(2, 2, TileType.ev, left: 1, top: 1, right: 1), //ev
      Tile(2, 2, TileType.road),
      Tile(18, 3, TileType.road, right: 1, left: 1),
      Tile(2, 1, TileType.road),
      Tile(2, 1, TileType.road, bottom: 1),
      Tile(2, 1, TileType.road),
      Tile(6, 6, TileType.road),
      Tile(12, 6, TileType.classroom,
          classroomNo: '50', txt: 'アトリエ', left: 1, bottom: 1), //アトリエ
      Tile(18, 1, TileType.road),
      Tile(6, 5, TileType.road, left: 1, bottom: 1, txt: 'プレゼンテーションベイB'),
      Tile(6, 5, TileType.road, bottom: 1, txt: 'プレゼンテーションベイG'),
      Tile(6, 5, TileType.road, right: 1, bottom: 1, txt: 'プレゼンテーションベイR'),
      Tile(2, 2, TileType.road, bottom: 1),
      Tile(2, 2, TileType.road),
      Tile(2, 2, TileType.road, bottom: 1),
      Tile(2, 2, TileType.road, bottom: 1),
      Tile(2, 2, TileType.otherroom, txt: '出入口'),
      Tile(2, 2, TileType.road, bottom: 1),
    ],
    "2": [
      Tile(48, 18, TileType.empty),
      Tile(40, 1, TileType.road, left: 1, top: 1),
      Tile(2, 3, TileType.otherroom, top: 1),
      Tile(6, 7, TileType.otherroom, top: 1, right: 1),
      Tile(1, 6, TileType.road, left: 1),
      Tile(3, 2, TileType.teacherroom, txt: '255'),
      Tile(2, 2, TileType.teacherroom, txt: '254'),
      Tile(2, 2, TileType.teacherroom, txt: '253'),
      Tile(2, 2, TileType.teacherroom, txt: '252'),
      Tile(2, 2, TileType.teacherroom, txt: '251'),
      Tile(1, 6, TileType.road),
      Tile(3, 6, TileType.wc, wc: 0x1101), // アトリエ側トイレ
      Tile(2, 2, TileType.otherroom),
      Tile(2, 2, TileType.teacherroom, txt: '250'),
      Tile(2, 2, TileType.teacherroom, txt: '249'),
      Tile(2, 2, TileType.teacherroom, txt: '248'),
      Tile(2, 2, TileType.teacherroom, txt: '247'),
      Tile(2, 2, TileType.teacherroom, txt: '246'),
      Tile(2, 2, TileType.teacherroom, txt: '245'),
      Tile(2, 2, TileType.teacherroom, txt: '244'),
      Tile(2, 2, TileType.teacherroom, txt: '243'),
      Tile(2, 2, TileType.wc, wc: 0x0100), // 購買側トイレ
      Tile(1, 6, TileType.road),
      Tile(3, 2, TileType.wc, wc: 0x1010), // 購買側トイレ
      Tile(1, 4, TileType.otherroom),
      Tile(2, 4, TileType.teacherroom, txt: '235'), //235
      Tile(2, 4, TileType.teacherroom, txt: '234'), //234
      Tile(2, 4, TileType.teacherroom, txt: '233'), //233
      Tile(2, 4, TileType.teacherroom, txt: '232'), //232
      Tile(2, 4, TileType.teacherroom, txt: '231'), //231
      Tile(2, 4, TileType.stair,
          top: 1,
          right: 1,
          left: 1,
          stairType: const StairType(Axis.vertical, true, false)), // アトリエ側階段
      Tile(2, 4, TileType.teacherroom, txt: '230'), //230
      Tile(2, 4, TileType.teacherroom, txt: '229'), //229
      Tile(2, 4, TileType.teacherroom, txt: '228'), //228
      Tile(2, 4, TileType.teacherroom, txt: '227'), //227
      Tile(2, 4, TileType.teacherroom, txt: '226'), //226
      Tile(2, 4, TileType.teacherroom, txt: '225'), //225
      Tile(2, 4, TileType.teacherroom, txt: '224'), //224
      Tile(2, 4, TileType.teacherroom, txt: '223'), //223
      Tile(2, 4, TileType.teacherroom, txt: '222'), //222
      Tile(1, 4, TileType.otherroom),
      Tile(2, 4, TileType.subroom, txt: '221'), //221
      Tile(2, 4, TileType.stair,
          top: 1,
          right: 1,
          left: 1,
          stairType: const StairType(Axis.vertical, true, false)), // 購買側階段
      Tile(42, 1, TileType.road, left: 1),
      Tile(6, 6, TileType.subroom, txt: '購買', right: 1, bottom: 1), //売店
      Tile(12, 5, TileType.otherroom, left: 1, bottom: 1),
      Tile(6, 1, TileType.road),
      Tile(17, 2, TileType.otherroom),
      Tile(1, 2, TileType.road, right: 1),
      Tile(6, 1, TileType.road),
      Tile(4, 4, TileType.road, bottom: 1),
      Tile(2, 4, TileType.stair,
          right: 1,
          bottom: 1,
          left: 1,
          stairType: const StairType(Axis.vertical, false, true)),
      Tile(4, 4, TileType.road),
      Tile(2, 4, TileType.stair,
          right: 1,
          bottom: 1,
          left: 1,
          stairType: const StairType(Axis.vertical, false, true)),
      Tile(18, 3, TileType.road, bottom: 1),
      Tile(36, 6, TileType.empty), //empty
      Tile(2, 6, TileType.road, left: 1, bottom: 1),
      Tile(10, 2, TileType.empty, top: 1, left: 1),
      Tile(2, 2, TileType.ev, top: 1, right: 1, left: 1), //ev
      Tile(8, 2, TileType.empty), //empty
      Tile(2, 1, TileType.road, right: 1, bottom: 1),
      Tile(8, 1, TileType.empty), //empty
      Tile(10, 1, TileType.empty, left: 1), //empty
    ],
    "3": [
      Tile(12, 18, TileType.classroom,
          txt: '体育館', top: 1, left: 1, classroomNo: '51'),
      Tile(6, 6, TileType.subroom, top: 1, txt: 'トレーニングルーム'),
      Tile(30, 6, TileType.empty, left: 1),
      Tile(4, 4, TileType.wc, wc: 0x1110), // 体育館トイレ
      Tile(2, 4, TileType.road),
      Tile(6, 12, TileType.classroom, txt: '工房', top: 1),
      Tile(6, 12, TileType.classroom, txt: 'エレクトロニクス工房', top: 1),
      Tile(6, 2, TileType.subroom, txt: '医務室', top: 1),
      Tile(2, 2, TileType.road, txt: '休日夜間入口'),
      Tile(6, 2, TileType.otherroom, top: 1),
      Tile(4, 3, TileType.otherroom, top: 1, right: 1),
      Tile(6, 4, TileType.subroom, txt: '映像音響スタジオ'),
      Tile(2, 10, TileType.road),
      Tile(6, 1, TileType.road),
      Tile(4, 3, TileType.otherroom),
      Tile(6, 2, TileType.otherroom, right: 1),
      Tile(1, 2, TileType.otherroom),
      Tile(1, 2, TileType.road),
      Tile(2, 2, TileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, true, false)), // 体育館側階段
      Tile(2, 2, TileType.road),
      Tile(6, 7, TileType.subroom, txt: 'ミュージアム', right: 1),
      Tile(6, 2, TileType.road),
      Tile(6, 6, TileType.subroom, txt: '社会連携センター'),
      Tile(2, 6, TileType.wc, wc: 0x1100), // 駐車場側トイレ
      Tile(2, 5, TileType.stair,
          top: 1,
          left: 1,
          right: 1,
          stairType: const StairType(Axis.vertical, true, false)), // 事務局行き階段
      Tile(4, 4, TileType.otherroom),
      Tile(2, 4, TileType.road),
      Tile(2, 1, TileType.road),
      Tile(48, 2, TileType.road, left: 1, right: 1), // モール
      Tile(2, 2, TileType.otherroom, txt: '研究棟入口'),
      Tile(12, 2, TileType.road),
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
      Tile(6, 2, TileType.road),
      Tile(2, 2, TileType.otherroom, txt: '正面\n入口'),
      Tile(48, 2, TileType.road, left: 1, right: 1), // モール
      Tile(12, 7, TileType.classroom, txt: '大講義室', left: 1, classroomNo: '2'),
      Tile(1, 7, TileType.otherroom),
      Tile(3, 5, TileType.subroom, txt: '心理学実験室'),
      Tile(2, 7, TileType.road),
      Tile(6, 7, TileType.classroom, txt: '365', classroomNo: '18'),
      Tile(6, 7, TileType.classroom, txt: '364', classroomNo: '17'),
      Tile(6, 7, TileType.classroom, txt: '363', classroomNo: '16'),
      Tile(4, 2, TileType.otherroom),
      Tile(2, 7, TileType.road),
      Tile(6, 37, TileType.subroom, txt: 'ライブラリ', right: 1, bottom: 1, left: 1),
      Tile(2, 5, TileType.wc, wc: 0x1000), // 入口側トイレ男
      Tile(2, 5, TileType.otherroom),
      Tile(3, 2, TileType.otherroom),
      Tile(42, 1, TileType.road, left: 1),
      Tile(1, 6, TileType.road, left: 1),
      Tile(3, 2, TileType.teacherroom, txt: '355'),
      Tile(2, 2, TileType.teacherroom, txt: '354'),
      Tile(2, 2, TileType.teacherroom, txt: '353'),
      Tile(2, 2, TileType.teacherroom, txt: '352'),
      Tile(2, 2, TileType.teacherroom, txt: '351'),
      Tile(4, 4, TileType.wc, wc: 0x1101), // 331側トイレ
      Tile(2, 6, TileType.road),
      Tile(2, 2, TileType.teacherroom, txt: '350'),
      Tile(2, 2, TileType.teacherroom, txt: '349'),
      Tile(2, 2, TileType.teacherroom, txt: '348'),
      Tile(2, 2, TileType.teacherroom, txt: '347'),
      Tile(2, 2, TileType.teacherroom, txt: '346'),
      Tile(2, 2, TileType.teacherroom, txt: '345'),
      Tile(2, 2, TileType.teacherroom, txt: '344'),
      Tile(2, 2, TileType.teacherroom, txt: '343'),
      Tile(2, 2, TileType.teacherroom, txt: '342'),
      Tile(4, 2, TileType.wc, wc: 0x0110), // 入口側トイレ女
      Tile(2, 6, TileType.road),
      Tile(1, 4, TileType.otherroom),
      Tile(2, 4, TileType.teacherroom, txt: '335'),
      Tile(2, 4, TileType.teacherroom, txt: '334'),
      Tile(2, 4, TileType.teacherroom, txt: '333'),
      Tile(2, 4, TileType.teacherroom, txt: '332'),
      Tile(2, 4, TileType.teacherroom, txt: '331'),
      Tile(2, 4, TileType.teacherroom, txt: '330'),
      Tile(2, 4, TileType.teacherroom, txt: '329'),
      Tile(2, 4, TileType.teacherroom, txt: '328'),
      Tile(2, 4, TileType.teacherroom, txt: '327'),
      Tile(2, 4, TileType.teacherroom, txt: '326'),
      Tile(2, 4, TileType.teacherroom, txt: '325'),
      Tile(2, 4, TileType.teacherroom, txt: '324'),
      Tile(2, 4, TileType.teacherroom, txt: '323'),
      Tile(2, 4, TileType.teacherroom, txt: '322'),
      Tile(2, 4, TileType.subroom, txt: '321'),
      Tile(4, 2, TileType.otherroom),
      Tile(2, 4, TileType.otherroom),
      Tile(42, 1, TileType.road, left: 1),
      Tile(12, 5, TileType.otherroom, left: 1, bottom: 1),
      Tile(4, 3, TileType.road),
      Tile(2, 1, TileType.road),
      Tile(2, 2, TileType.otherroom),
      Tile(1, 2, TileType.road),
      Tile(14, 2, TileType.otherroom),
      Tile(1, 2, TileType.road),
      Tile(4, 3, TileType.road),
      Tile(2, 1, TileType.road),
      Tile(2, 4, TileType.stair,
          bottom: 1,
          left: 1,
          right: 1,
          stairType: const StairType(Axis.vertical, false, true)), // 階段331側下り
      Tile(2, 4, TileType.stair,
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
          txt: '体育館', top: 1, left: 1, bottom: 1, right: 1),
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
      Tile(2, 2, TileType.otherroom, top: 1, txt: '証明書発行機'),
      Tile(6, 10, TileType.subroom, txt: '事務局', top: 1, right: 1),
      Tile(2, 4, TileType.road),
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
      Tile(5, 2, TileType.subroom, txt: '局長室', right: 1, bottom: 1),
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
      Tile(2, 2, TileType.subroom, txt: 'S-15', top: 1, left: 1), //文字はみ出してる
      Tile(2, 2, TileType.subroom, txt: 'S-14', top: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-13', top: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-12', top: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-11', top: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-10', top: 1),
      Tile(1, 2, TileType.otherroom, top: 1),
      Tile(1, 2, TileType.wc, wc: 0x0001, top: 1, right: 1),
      Tile(2, 2, TileType.empty, bottom: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-9', top: 1, left: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-8', top: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-7', top: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-6', top: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-5', top: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-4', top: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-3', top: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-2', top: 1),
      Tile(2, 2, TileType.subroom, txt: 'S-1', top: 1),
      Tile(1, 2, TileType.otherroom, top: 1),
      Tile(1, 2, TileType.otherroom, txt: '倉庫', top: 1, right: 1),
      Tile(2, 2, TileType.empty, bottom: 1, right: 1),
      Tile(2, 2, TileType.otherroom, top: 1),
      Tile(3, 3, TileType.subroom, txt: '理事室', top: 1, right: 1),
      Tile(43, 1, TileType.road, left: 1),
      Tile(2, 5, TileType.subroom, txt: '秘書室'),
      Tile(1, 4, TileType.road, left: 1),
      Tile(1, 4, TileType.otherroom, txt: '倉庫'),
      Tile(2, 4, TileType.teacherroom, txt: '435'),
      Tile(2, 4, TileType.teacherroom, txt: '434'),
      Tile(2, 4, TileType.teacherroom, txt: '433'),
      Tile(2, 4, TileType.teacherroom, txt: '432'),
      Tile(2, 4, TileType.teacherroom, txt: '431'),
      Tile(2, 4, TileType.road),
      Tile(2, 3, TileType.wc, wc: 0x1100, right: 1),
      Tile(2, 10, TileType.empty, top: 1),
      Tile(1, 2, TileType.otherroom, txt: '印刷', left: 1),
      Tile(1, 4, TileType.road),
      Tile(2, 4, TileType.teacherroom, txt: '429'),
      Tile(2, 4, TileType.teacherroom, txt: '428'),
      Tile(2, 4, TileType.teacherroom, txt: '427'),
      Tile(2, 4, TileType.teacherroom, txt: '426'),
      Tile(2, 4, TileType.teacherroom, txt: '425'),
      Tile(2, 4, TileType.teacherroom, txt: '424'),
      Tile(2, 4, TileType.teacherroom, txt: '423'),
      Tile(2, 4, TileType.subroom, txt: '422'),
      Tile(2, 4, TileType.road),
      Tile(2, 3, TileType.wc, wc: 0x1100, right: 1),
      Tile(2, 10, TileType.empty, top: 1, right: 1),
      Tile(1, 9, TileType.road),
      Tile(3, 4, TileType.subroom, txt: '学長室', right: 1),
      Tile(1, 2, TileType.otherroom, txt: '倉庫', left: 1),
      Tile(2, 1, TileType.otherroom, right: 1),
      Tile(2, 1, TileType.otherroom, right: 1),
      Tile(14, 1, TileType.road, left: 1),
      Tile(2, 3, TileType.subroom, txt: 'M402', right: 1),
      Tile(22, 1, TileType.road, right: 1, left: 1),
      Tile(5, 4, TileType.subroom, txt: '特別応接室', right: 1),
      Tile(12, 5, TileType.otherroom, left: 1, bottom: 1),
      Tile(2, 5, TileType.road),
      Tile(18, 3, TileType.otherroom, left: 1),
      Tile(2, 5, TileType.road),
      Tile(2, 5, TileType.road, txt: 'ラウンジ', right: 1, bottom: 1),
      Tile(2, 3, TileType.subroom, txt: 'M401', bottom: 1, right: 1),
      Tile(6, 2, TileType.otherroom, bottom: 1, left: 1),
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
      Tile(3, 3, TileType.subroom, txt: 'サーバーコンピュータ事務室'),
      Tile(2, 3, TileType.wc, wc: 0x1101, right: 1), // サーバーコンピュータ室側トイレ
      Tile(5, 4, TileType.subroom, txt: 'サーバーコンピュータ室', right: 1),
      Tile(2, 2, TileType.stair, top: 1, right: 1, bottom: 1),
      Tile(20, 2, TileType.empty, bottom: 1, right: 1),
      Tile(2, 2, TileType.stair, top: 1, right: 1, bottom: 1),
      Tile(2, 2, TileType.empty, right: 1),
      Tile(26, 1, TileType.road),
      Tile(4, 8, TileType.empty, left: 1, right: 1),
      Tile(6, 12, TileType.classroom,
          txt: '講堂', classroomNo: '1', top: 1, right: 1, bottom: 1),
      Tile(4, 11, TileType.subroom, txt: 'デルタビスタ', right: 1, bottom: 1),
      Tile(20, 11, TileType.empty, top: 1, right: 1),
      Tile(2, 9, TileType.road),
      Tile(2, 2, TileType.ev, txt: 'ev', left: 1, top: 1, right: 1),
      Tile(2, 2, TileType.empty, right: 1, bottom: 1),
      Tile(6, 2, TileType.road, bottom: 1)
    ],
    "5": [
      Tile(14, 2, TileType.otherroom,
          top: 1,
          left: 1,
          innerWidget: subTile(9, mapCircle7To15TileList)), //サークル1
      Tile(2, 10, TileType.otherroom,
          right: 1,
          top: 1,
          innerWidget: subTile(5, mapCircle6To1TileList)), //サークル3
      Tile(32, 6, TileType.empty), //empty
      Tile(14, 1, TileType.road, left: 1),
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
      Tile(6, 12, TileType.otherroom,
          top: 1, right: 1, bottom: 1, txt: '共同研究室'),
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
      Tile(4, 8, TileType.otherroom, top: 1, right: 1, txt: '会議室'),
      Tile(2, 4, TileType.teacherroom, txt: '536', left: 1),
      Tile(2, 4, TileType.teacherroom, txt: '535'),
      Tile(2, 4, TileType.teacherroom, txt: '534'),
      Tile(2, 4, TileType.teacherroom, txt: '533'),
      Tile(2, 4, TileType.teacherroom, txt: '532'),
      Tile(2, 4, TileType.teacherroom, txt: '531'),
      Tile(2, 4, TileType.road),
      Tile(2, 4, TileType.otherroom, right: 1),
      Tile(2, 4, TileType.empty, top: 1, bottom: 1), //吹き抜け
      Tile(1, 4, TileType.wc, left: 1, wc: 0x0001),
      Tile(1, 4, TileType.road),
      Tile(2, 4, TileType.teacherroom, txt: '529'),
      Tile(2, 4, TileType.teacherroom, txt: '528'),
      Tile(2, 4, TileType.teacherroom, txt: '527'),
      Tile(2, 4, TileType.teacherroom, txt: '526'),
      Tile(2, 4, TileType.teacherroom, txt: '525'),
      Tile(2, 4, TileType.teacherroom, txt: '524'),
      Tile(2, 4, TileType.teacherroom, txt: '523'),
      Tile(2, 4, TileType.teacherroom, txt: '522'),
      Tile(2, 4, TileType.road),
      Tile(44, 1, TileType.road, left: 1),
      Tile(12, 2, TileType.otherroom, left: 1, bottom: 1), //スタジオleft
      Tile(2, 2, TileType.road),
      Tile(2, 2, TileType.subroom, right: 1, bottom: 1, txt: '大学生協学生委員室'),
      Tile(2, 2, TileType.empty, top: 1), //吹き抜け
      Tile(18, 2, TileType.otherroom, left: 1, bottom: 1), //スタジオcenter
      Tile(2, 11, TileType.road),
      Tile(2, 2, TileType.subroom, right: 1, bottom: 1, txt: 'M502'),
      Tile(2, 2, TileType.empty, top: 1, right: 1), //吹き抜け
      Tile(2, 4, TileType.road),
      Tile(12, 12, TileType.empty, right: 1), //empty left
      Tile(2, 12, TileType.road, bottom: 1),
      Tile(22, 10, TileType.empty, left: 1, right: 1), //empty center
      Tile(4, 9, TileType.empty, left: 1, right: 1, bottom: 1), //empty right
      Tile(4, 2, TileType.subroom, right: 1, txt: 'M501'),
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
      Tile(4, 2, TileType.otherroom, txt: '調整室'), //調光室
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
    "R6": [
      Tile(4, 2, TileType.teacherroom, txt: 'R611', top: 1, left: 1),
      Tile(1, 30, TileType.road, top: 1, bottom: 1),
      Tile(3, 3, TileType.otherroom, top: 1),
      Tile(3, 3, TileType.subroom, top: 1, txt: 'R627'),
      Tile(2, 30, TileType.road, top: 1, bottom: 1),
      Tile(4, 4, TileType.subroom, top: 1, txt: 'R637'),
      Tile(4, 14, TileType.road, top: 1),
      Tile(1, 24, TileType.road, top: 1),
      Tile(4, 2, TileType.subroom, txt: 'R657', top: 1, right: 1),
      Tile(22, 30, TileType.empty),
      Tile(4, 2, TileType.teacherroom, txt: 'R610', left: 1),
      Tile(4, 2, TileType.teacherroom, txt: 'R656', right: 1),
      Tile(6, 1, TileType.road),
      Tile(4, 2, TileType.road, left: 1),
      Tile(3, 20, TileType.otherroom),
      Tile(3, 4, TileType.otherroom, txt: 'R626'),
      Tile(4, 4, TileType.subroom, txt: 'R636'),
      Tile(4, 2, TileType.road, right: 1),
      Tile(4, 2, TileType.stair,
          left: 1,
          top: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, true, false)),
      Tile(4, 2, TileType.stair,
          right: 1,
          top: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, true, false)),
      Tile(4, 2, TileType.teacherroom, txt: 'R609', left: 1),
      Tile(3, 4, TileType.subroom, txt: 'R625'),
      Tile(4, 3, TileType.subroom, txt: 'R635'),
      Tile(4, 2, TileType.teacherroom, txt: 'R655', right: 1),
      Tile(4, 2, TileType.teacherroom, left: 1, txt: 'R608'),
      Tile(4, 2, TileType.teacherroom, txt: 'R654', right: 1),
      Tile(4, 3, TileType.subroom, txt: 'R634'),
      Tile(4, 2, TileType.teacherroom, left: 1, txt: 'R607'),
      Tile(3, 4, TileType.subroom, txt: 'R624'),
      Tile(4, 2, TileType.teacherroom, txt: 'R653', right: 1),
      Tile(4, 2, TileType.subroom, txt: 'R606', left: 1),
      Tile(4, 2, TileType.subroom, txt: 'R633'),
      Tile(4, 2, TileType.otherroom),
      Tile(4, 2, TileType.subroom, right: 1, txt: 'R652'),
      Tile(4, 2, TileType.teacherroom, txt: 'R605', left: 1),
      Tile(3, 4, TileType.subroom, txt: 'R623'),
      Tile(4, 4, TileType.subroom, txt: 'R632'),
      Tile(4, 4, TileType.subroom, txt: 'R642'),
      Tile(4, 6, TileType.subroom, right: 1, txt: 'R651'),
      Tile(4, 2, TileType.teacherroom, txt: 'R604', left: 1),
      Tile(4, 2, TileType.stair,
          left: 1,
          top: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, true, false)),
      Tile(3, 4, TileType.otherroom, txt: 'R622'),
      Tile(8, 2, TileType.road),
      Tile(4, 2, TileType.road, left: 1),
      Tile(4, 4, TileType.subroom, txt: 'R631'),
      Tile(2, 2, TileType.ev),
      Tile(2, 2, TileType.stair,
          left: 1,
          right: 1,
          bottom: 1,
          stairType: const StairType(Axis.vertical, true, false)),
      Tile(4, 2, TileType.otherroom, right: 1),
      Tile(4, 2, TileType.teacherroom, txt: 'R603', left: 1),
      Tile(6, 1, TileType.road),
      Tile(5, 4, TileType.subroom, txt: 'R641', right: 1),
      Tile(4, 6, TileType.empty, top: 1),
      Tile(3, 5, TileType.otherroom, bottom: 1),
      Tile(3, 3, TileType.subroom, txt: 'R621'),
      Tile(4, 2, TileType.subroom, txt: 'R602', left: 1),
      Tile(4, 4, TileType.wc, wc: 0x1110, bottom: 1),
      Tile(4, 2, TileType.teacherroom, txt: 'R601', left: 1, bottom: 1),
      Tile(2, 2, TileType.otherroom, bottom: 1),
      Tile(1, 2, TileType.otherroom, bottom: 1),
      Tile(4, 2, TileType.subroom, bottom: 1),
      Tile(1, 2, TileType.subroom, bottom: 1, right: 1),
    ],
    "R7": [
      Tile(4, 2, TileType.subroom, txt: 'R711', top: 1, left: 1),
      Tile(1, 30, TileType.road, top: 1, bottom: 1),
      Tile(3, 3, TileType.empty, bottom: 1, left: 1),
      Tile(2, 3, TileType.otherroom, left: 1, top: 1, right: 1),
      Tile(3, 3, TileType.empty, bottom: 1),
      Tile(2, 3, TileType.empty),
      Tile(2, 9, TileType.otherroom, left: 1, top: 1, right: 1),
      Tile(4, 9, TileType.empty, right: 1, bottom: 1),
      Tile(1, 14, TileType.road, top: 1),
      Tile(4, 2, TileType.teacherroom, txt: 'R757', top: 1, right: 1),
      Tile(22, 20, TileType.empty, bottom: 1),
      Tile(4, 2, TileType.subroom, txt: 'R710', left: 1),
      Tile(4, 2, TileType.teacherroom, txt: 'R756', right: 1),
      Tile(6, 1, TileType.road),
      Tile(2, 22, TileType.road),
      Tile(2, 6, TileType.empty, left: 1, bottom: 1),
      Tile(4, 2, TileType.road, left: 1),
      Tile(6, 4, TileType.empty, left: 1, top: 1, right: 1),
      Tile(4, 2, TileType.road, right: 1),
      Tile(4, 2, TileType.stair,
          left: 1,
          top: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, false, true)),
      Tile(4, 2, TileType.stair,
          right: 1,
          top: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, false, true)),
      Tile(4, 2, TileType.subroom, txt: 'R709', left: 1),
      Tile(4, 12, TileType.empty, left: 1),
      Tile(2, 4, TileType.subroom, txt: 'R725', left: 1, top: 1),
      Tile(4, 2, TileType.subroom, txt: 'R755', right: 1),
      Tile(8, 1, TileType.road),
      Tile(4, 4, TileType.otherroom, left: 1),
      Tile(8, 4, TileType.empty, left: 1, top: 1, right: 1, bottom: 1),
      Tile(4, 2, TileType.subroom, txt: 'R754', right: 1),
      Tile(2, 4, TileType.subroom, txt: 'R724', left: 1),
      Tile(4, 2, TileType.subroom, txt: 'R753', right: 1),
      Tile(4, 2, TileType.subroom, txt: 'R706', left: 1),
      Tile(2, 2, TileType.otherroom),
      Tile(2, 2, TileType.otherroom),
      Tile(9, 6, TileType.otherroom, right: 1),
      Tile(4, 2, TileType.subroom, txt: 'R705', left: 1),
      Tile(2, 4, TileType.subroom, txt: 'R723', left: 1, bottom: 1),
      Tile(4, 4, TileType.subroom, txt: 'R731'),
      Tile(4, 2, TileType.subroom, txt: 'R704', left: 1),
      Tile(4, 2, TileType.stair,
          left: 1,
          top: 1,
          bottom: 1,
          stairType: const StairType(Axis.horizontal, false, true)),
      Tile(6, 4, TileType.empty, left: 1, bottom: 1, right: 1),
      Tile(30, 2, TileType.road),
      Tile(5, 10, TileType.classroom,
          txt: 'R791', right: 1, bottom: 1, classroomNo: '7'),
      Tile(4, 2, TileType.road, left: 1),
      Tile(3, 3, TileType.empty, left: 1, top: 1, right: 1),
      Tile(1, 7, TileType.road),
      Tile(2, 2, TileType.ev),
      Tile(2, 2, TileType.stair,
          left: 1,
          right: 1,
          stairType: const StairType(Axis.vertical, false, true)),
      Tile(1, 2, TileType.otherroom),
      Tile(4, 2, TileType.subroom, txt: 'R751'),
      Tile(5, 2, TileType.otherroom),
      Tile(4, 8, TileType.classroom, txt: 'R781', classroomNo: '14', bottom: 1),
      Tile(4, 8, TileType.classroom, txt: 'R782', classroomNo: '15', bottom: 1),
      Tile(2, 2, TileType.ev),
      Tile(2, 2, TileType.road),
      Tile(4, 2, TileType.subroom, txt: 'R703', left: 1),
      Tile(6, 1, TileType.road),
      Tile(5, 4, TileType.empty, top: 1, left: 1),
      Tile(9, 6, TileType.empty, right: 1, top: 1),
      Tile(4, 2, TileType.road),
      Tile(3, 5, TileType.empty, top: 1, left: 1),
      Tile(2, 5, TileType.otherroom, bottom: 1, left: 1),
      Tile(3, 3, TileType.empty, left: 1, top: 1),
      Tile(3, 1, TileType.empty, right: 1),
      Tile(4, 2, TileType.subroom, txt: 'R702', left: 1),
      Tile(3, 4, TileType.wc, left: 1, top: 1, bottom: 1, wc: 0x1100),
      Tile(1, 2, TileType.stair,
          right: 1,
          bottom: 1,
          left: 1,
          stairType: const StairType(Axis.vertical, true, false)),
      Tile(1, 2, TileType.road),
      Tile(2, 2, TileType.wc, wc: 0x0010),
      Tile(4, 2, TileType.subroom, txt: 'R701', left: 1, bottom: 1),
      Tile(1, 2, TileType.otherroom, right: 1, top: 1, bottom: 1),
      Tile(2, 2, TileType.empty),
      Tile(5, 2, TileType.otherroom, bottom: 1, right: 1, top: 1),
      Tile(2, 2, TileType.wc, bottom: 1, wc: 0x0100),
      Tile(2, 2, TileType.wc, bottom: 1, wc: 0x1000),
      Tile(1, 1, TileType.wc, bottom: 1),
    ],
  };

  static final List<Tile> mapCircle7To15TileList = [
    Tile(1, 1, TileType.subroom, txt: 'サークル室15'),
    Tile(1, 1, TileType.subroom, txt: 'サークル室14'),
    Tile(1, 1, TileType.subroom, txt: 'サークル室13'),
    Tile(1, 1, TileType.subroom, txt: 'サークル室12'),
    Tile(1, 1, TileType.subroom, txt: 'サークル室11'),
    Tile(1, 1, TileType.subroom, txt: 'サークル室10'),
    Tile(1, 1, TileType.subroom, txt: 'サークル室9'),
    Tile(1, 1, TileType.subroom, txt: 'サークル室8'),
    Tile(1, 1, TileType.subroom, txt: 'サークル室7'),
  ];

  static final List<Tile> mapCircle6To1TileList = [
    Tile(5, 8, TileType.subroom, txt: 'サークル室6', fontSize: 3),
    Tile(5, 4, TileType.subroom, txt: 'サークル室5', fontSize: 3),
    Tile(5, 4, TileType.subroom, txt: 'サークル室4', fontSize: 3),
    Tile(5, 4, TileType.subroom, txt: 'サークル室3', fontSize: 3),
    Tile(5, 4, TileType.subroom, txt: 'サークル室2', fontSize: 3),
    Tile(5, 4, TileType.subroom, txt: 'サークル室1', fontSize: 3),
  ];

  static Widget subTile(int count, List<Tile> tileList) {
    return StaggeredGrid.count(
      crossAxisCount: count,
      children: [
        ...tileList.map(
          (e) {
            return StaggeredGridTile.count(
                crossAxisCellCount: e.width,
                mainAxisCellCount: e.height,
                child: e);
          },
        )
      ],
    );
  }
}
