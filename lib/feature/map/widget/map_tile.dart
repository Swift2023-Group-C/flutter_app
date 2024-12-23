import 'package:dotto/importer.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:dotto/feature/map/domain/map_tile_type.dart';
import 'package:dotto/feature/map/widget/map_detail_bottom_sheet.dart';

abstract final class MapColors {
  static Color get using => Colors.orange.shade300;
  static Color get wcMan => Colors.blue.shade800;
  static Color get wcWoman => Colors.red.shade800;
}

// 階段の時の描画設定
class MapStairType {
  final Axis direction;
  final bool up;
  final bool down;
  const MapStairType(this.direction, this.up, this.down);
  Axis getDirection() {
    return direction;
  }
}

/// require width, height: Size, require ttype: タイルタイプ enum
///
/// top, right, bottom, left: Borderサイズ, txt
// ignore: must_be_immutable
class MapTile extends StatelessWidget {
  final int width;
  final int height;
  final MapTileType ttype;
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
  final MapStairType stairType;
  DateTime? useEndTime;
  final Widget? innerWidget;
  final bool? food;
  final bool? drink;
  final int? outlet;

  MapTile(
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
    this.stairType = const MapStairType(Axis.horizontal, true, true),
    this.useEndTime,
    this.innerWidget,
    this.food,
    this.drink,
    this.outlet,
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
    tileColor = ttype.backgroundColor;
    fontColor = ttype.textColor;
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
    int iconLength =
        (wc & 0x0001) + (wc & 0x0010) ~/ 0x0010 + (wc & 0x0100) ~/ 0x0100 + (wc & 0x1000) ~/ 0x1000;
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
    if (ttype == MapTileType.ev) {
      return const Icon(
        Icons.elevator_outlined,
        size: 12,
        color: Colors.white,
        weight: 100,
      );
    }
    if (ttype == MapTileType.stair) {
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
    List<String> floorBarString = ['5', '4', '3', '2', '1', 'R6', 'R7'];
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
              tileColor = MapColors.using;
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
              color: (ttype == MapTileType.empty) ? tileColor : MapTileType.road.backgroundColor,
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
    if (ttype == MapTileType.stair) {
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
      final mapSearchBarFocusNotifier = ref.watch(mapSearchBarFocusProvider.notifier);
      ref.watch(mapUsingMapProvider);
      return GestureDetector(
        onTap: (txt.isNotEmpty && ttype.index <= MapTileType.subroom.index)
            ? () {
                showBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return MapDetailBottomSheet(floor: floorBarString[mapPage], roomName: txt);
                  },
                );
                mapSearchBarFocusNotifier.state.unfocus();
              }
            : null,
        child: Stack(
            alignment: AlignmentDirectional.center, fit: StackFit.loose, children: widgetList),
      );
    });
  }
}
