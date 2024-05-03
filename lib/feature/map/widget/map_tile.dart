import 'package:dotto/importer.dart';

import 'package:dotto/app.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';

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
