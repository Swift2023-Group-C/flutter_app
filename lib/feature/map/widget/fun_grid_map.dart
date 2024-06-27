import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:dotto/importer.dart';
import 'package:dotto/feature/map/domain/map_tile_type.dart';
import 'package:dotto/feature/map/widget/map_tile.dart';

abstract final class FunGridMaps {
  static final Map<String, List<MapTile>> mapTileListMap = {
    "1": [
      MapTile(48, 18, MapTileType.empty),
      MapTile(40, 7, MapTileType.empty),
      MapTile(8, 7, MapTileType.otherroom, left: 1, top: 1, right: 1),
      MapTile(40, 1, MapTileType.road, left: 1, top: 1),
      MapTile(2, 3, MapTileType.otherroom),
      MapTile(6, 4, MapTileType.otherroom, right: 1),
      MapTile(1, 6, MapTileType.road, left: 1),
      MapTile(1, 6, MapTileType.otherroom),
      MapTile(2, 2, MapTileType.teacherroom, txt: '155'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '154'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '153'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '152'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '151'),
      MapTile(1, 6, MapTileType.road),
      MapTile(3, 6, MapTileType.wc, wc: 0x1101), // アトリエ側トイレ
      MapTile(2, 2, MapTileType.otherroom),
      MapTile(2, 2, MapTileType.teacherroom, txt: '150'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '149'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '148'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '147'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '146'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '145'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '144'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '143'),
      MapTile(2, 2, MapTileType.wc, wc: 0x0100), // 食堂側トイレ
      MapTile(1, 2, MapTileType.road),
      MapTile(3, 2, MapTileType.wc, wc: 0x1010), // 食堂側トイレ
      MapTile(2, 4, MapTileType.teacherroom, txt: '135'), //135
      MapTile(2, 4, MapTileType.teacherroom, txt: '134'), //134
      MapTile(2, 4, MapTileType.teacherroom, txt: '133'), //133
      MapTile(2, 4, MapTileType.teacherroom, txt: '132'), //132
      MapTile(2, 4, MapTileType.teacherroom, txt: '131'), //131
      MapTile(2, 4, MapTileType.stair,
          top: 1, left: 1, right: 1, stairType: const MapStairType(Axis.vertical, true, false)),
      MapTile(2, 4, MapTileType.teacherroom, txt: '130'), //130
      MapTile(2, 4, MapTileType.teacherroom, txt: '129'), //129
      MapTile(2, 4, MapTileType.teacherroom, txt: '128'), //128
      MapTile(2, 4, MapTileType.teacherroom, txt: '127'), //127
      MapTile(2, 4, MapTileType.teacherroom, txt: '126'), //126
      MapTile(2, 4, MapTileType.teacherroom, txt: '125'), //125
      MapTile(2, 4, MapTileType.teacherroom, txt: '124'), //124
      MapTile(2, 4, MapTileType.teacherroom, txt: '123'), //123
      MapTile(2, 4, MapTileType.subroom, txt: '122'), //122
      MapTile(1, 4, MapTileType.road, vendingMachine: 2),
      MapTile(1, 4, MapTileType.otherroom),
      MapTile(2, 4, MapTileType.subroom, txt: '121'), //121
      MapTile(2, 4, MapTileType.stair,
          top: 1, left: 1, right: 1, stairType: const MapStairType(Axis.vertical, true, false)),
      MapTile(6, 16, MapTileType.subroom, right: 1, bottom: 1, txt: '食堂'), //食堂
      MapTile(42, 1, MapTileType.road, left: 1),
      MapTile(12, 6, MapTileType.otherroom, left: 1),
      MapTile(6, 10, MapTileType.road),
      MapTile(18, 3, MapTileType.otherroom, right: 1, left: 1),
      MapTile(6, 1, MapTileType.road),
      MapTile(2, 2, MapTileType.road),
      MapTile(2, 2, MapTileType.ev, left: 1, top: 1, right: 1), //ev
      MapTile(2, 2, MapTileType.road),
      MapTile(18, 3, MapTileType.road, right: 1, left: 1),
      MapTile(2, 1, MapTileType.road),
      MapTile(2, 1, MapTileType.road, bottom: 1),
      MapTile(2, 1, MapTileType.road),
      MapTile(6, 6, MapTileType.road),
      MapTile(12, 6, MapTileType.classroom,
          classroomNo: '50', txt: 'アトリエ', left: 1, bottom: 1), //アトリエ
      MapTile(18, 1, MapTileType.road),
      MapTile(6, 5, MapTileType.road, left: 1, bottom: 1, txt: 'プレゼンテーションベイB'),
      MapTile(6, 5, MapTileType.road, bottom: 1, txt: 'プレゼンテーションベイG'),
      MapTile(6, 5, MapTileType.road, right: 1, bottom: 1, txt: 'プレゼンテーションベイR'),
      MapTile(2, 2, MapTileType.road, bottom: 1),
      MapTile(2, 2, MapTileType.road),
      MapTile(2, 2, MapTileType.road, bottom: 1),
      MapTile(2, 2, MapTileType.road, bottom: 1),
      MapTile(2, 2, MapTileType.otherroom, txt: '出入口'),
      MapTile(2, 2, MapTileType.road, bottom: 1),
    ],
    "2": [
      MapTile(48, 18, MapTileType.empty),
      MapTile(40, 1, MapTileType.road, left: 1, top: 1),
      MapTile(2, 3, MapTileType.otherroom, top: 1),
      MapTile(6, 7, MapTileType.otherroom, top: 1, right: 1),
      MapTile(1, 6, MapTileType.road, left: 1),
      MapTile(3, 2, MapTileType.teacherroom, txt: '255'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '254'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '253'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '252'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '251'),
      MapTile(1, 6, MapTileType.road),
      MapTile(3, 6, MapTileType.wc, wc: 0x1101), // アトリエ側トイレ
      MapTile(2, 2, MapTileType.otherroom),
      MapTile(2, 2, MapTileType.teacherroom, txt: '250'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '249'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '248'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '247'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '246'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '245'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '244'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '243'),
      MapTile(2, 2, MapTileType.wc, wc: 0x0100), // 購買側トイレ
      MapTile(1, 6, MapTileType.road),
      MapTile(3, 2, MapTileType.wc, wc: 0x1010), // 購買側トイレ
      MapTile(1, 4, MapTileType.otherroom),
      MapTile(2, 4, MapTileType.teacherroom, txt: '235'), //235
      MapTile(2, 4, MapTileType.teacherroom, txt: '234'), //234
      MapTile(2, 4, MapTileType.teacherroom, txt: '233'), //233
      MapTile(2, 4, MapTileType.teacherroom, txt: '232'), //232
      MapTile(2, 4, MapTileType.teacherroom, txt: '231'), //231
      MapTile(2, 4, MapTileType.stair,
          top: 1,
          right: 1,
          left: 1,
          stairType: const MapStairType(Axis.vertical, true, false)), // アトリエ側階段
      MapTile(2, 4, MapTileType.teacherroom, txt: '230'), //230
      MapTile(2, 4, MapTileType.teacherroom, txt: '229'), //229
      MapTile(2, 4, MapTileType.teacherroom, txt: '228'), //228
      MapTile(2, 4, MapTileType.teacherroom, txt: '227'), //227
      MapTile(2, 4, MapTileType.teacherroom, txt: '226'), //226
      MapTile(2, 4, MapTileType.teacherroom, txt: '225'), //225
      MapTile(2, 4, MapTileType.teacherroom, txt: '224'), //224
      MapTile(2, 4, MapTileType.teacherroom, txt: '223'), //223
      MapTile(2, 4, MapTileType.teacherroom, txt: '222'), //222
      MapTile(1, 4, MapTileType.otherroom),
      MapTile(2, 4, MapTileType.subroom, txt: '221'), //221
      MapTile(2, 4, MapTileType.stair,
          top: 1,
          right: 1,
          left: 1,
          stairType: const MapStairType(Axis.vertical, true, false)), // 購買側階段
      MapTile(42, 1, MapTileType.road, left: 1),
      MapTile(6, 6, MapTileType.subroom, txt: '購買', right: 1, bottom: 1), //売店
      MapTile(12, 5, MapTileType.otherroom, left: 1, bottom: 1),
      MapTile(6, 1, MapTileType.road),
      MapTile(17, 2, MapTileType.otherroom),
      MapTile(1, 2, MapTileType.road, right: 1),
      MapTile(6, 1, MapTileType.road),
      MapTile(4, 4, MapTileType.road, bottom: 1),
      MapTile(2, 4, MapTileType.stair,
          right: 1, bottom: 1, left: 1, stairType: const MapStairType(Axis.vertical, false, true)),
      MapTile(4, 4, MapTileType.road),
      MapTile(2, 4, MapTileType.stair,
          right: 1, bottom: 1, left: 1, stairType: const MapStairType(Axis.vertical, false, true)),
      MapTile(18, 3, MapTileType.road, bottom: 1),
      MapTile(36, 6, MapTileType.empty), //empty
      MapTile(2, 6, MapTileType.road, left: 1, bottom: 1),
      MapTile(10, 2, MapTileType.empty, top: 1, left: 1),
      MapTile(2, 2, MapTileType.ev, top: 1, right: 1, left: 1), //ev
      MapTile(8, 2, MapTileType.empty), //empty
      MapTile(2, 1, MapTileType.road, right: 1, bottom: 1),
      MapTile(8, 1, MapTileType.empty), //empty
      MapTile(10, 1, MapTileType.empty, left: 1), //empty
    ],
    "3": [
      MapTile(12, 18, MapTileType.classroom, txt: '体育館', top: 1, left: 1, classroomNo: '51'),
      MapTile(6, 6, MapTileType.subroom, top: 1, txt: 'トレーニングルーム'),
      MapTile(30, 6, MapTileType.empty, left: 1),
      MapTile(4, 4, MapTileType.wc, wc: 0x1110), // 体育館トイレ
      MapTile(2, 4, MapTileType.road),
      MapTile(6, 12, MapTileType.classroom, txt: '工房', top: 1),
      MapTile(6, 12, MapTileType.classroom, txt: 'エレクトロニクス工房', top: 1),
      MapTile(6, 2, MapTileType.subroom, txt: '医務室', top: 1),
      MapTile(2, 2, MapTileType.road, txt: '休日夜間入口'),
      MapTile(6, 2, MapTileType.otherroom, top: 1),
      MapTile(4, 3, MapTileType.otherroom, top: 1, right: 1),
      MapTile(6, 4, MapTileType.subroom, txt: '映像音響スタジオ'),
      MapTile(2, 4, MapTileType.road),
      MapTile(6, 1, MapTileType.road),
      MapTile(4, 3, MapTileType.otherroom),
      MapTile(6, 2, MapTileType.otherroom, right: 1),
      MapTile(1, 2, MapTileType.otherroom),
      MapTile(1, 2, MapTileType.road),
      MapTile(2, 2, MapTileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const MapStairType(Axis.horizontal, true, false)), // 体育館側階段
      MapTile(2, 2, MapTileType.road),
      MapTile(6, 7, MapTileType.subroom, txt: 'ミュージアム', right: 1),
      MapTile(4, 2, MapTileType.road, vendingMachine: 1),
      MapTile(2, 2, MapTileType.road),
      MapTile(6, 6, MapTileType.subroom, txt: '社会連携センター'),
      MapTile(2, 6, MapTileType.road, vendingMachine: 3),
      MapTile(2, 6, MapTileType.wc, wc: 0x1100), // 駐車場側トイレ
      MapTile(2, 5, MapTileType.stair,
          top: 1,
          left: 1,
          right: 1,
          stairType: const MapStairType(Axis.vertical, true, false)), // 事務局行き階段
      MapTile(4, 4, MapTileType.otherroom),
      MapTile(2, 4, MapTileType.road),
      MapTile(2, 1, MapTileType.road),
      MapTile(48, 2, MapTileType.road, left: 1, right: 1), // モール
      MapTile(2, 2, MapTileType.otherroom, txt: '研究棟入口'),
      MapTile(12, 2, MapTileType.road),
      MapTile(2, 2, MapTileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const MapStairType(Axis.horizontal, true, false)), // モール体育館側階段
      MapTile(18, 2, MapTileType.road),
      MapTile(2, 2, MapTileType.ev, top: 1, left: 1, bottom: 1), // モールエレベーター
      MapTile(2, 2, MapTileType.road),
      MapTile(2, 2, MapTileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const MapStairType(Axis.horizontal, true, false)), // モール入口側階段
      MapTile(6, 2, MapTileType.road),
      MapTile(2, 2, MapTileType.otherroom, txt: '正面\n入口'),
      MapTile(48, 2, MapTileType.road, left: 1, right: 1), // モール
      MapTile(12, 7, MapTileType.classroom, txt: '大講義室', left: 1, classroomNo: '2'),
      MapTile(1, 7, MapTileType.otherroom),
      MapTile(3, 5, MapTileType.subroom, txt: '心理学実験室'),
      MapTile(2, 7, MapTileType.road),
      MapTile(6, 7, MapTileType.classroom, txt: '365', classroomNo: '18'),
      MapTile(6, 7, MapTileType.classroom, txt: '364', classroomNo: '17'),
      MapTile(6, 7, MapTileType.classroom, txt: '363', classroomNo: '16'),
      MapTile(4, 2, MapTileType.otherroom),
      MapTile(2, 7, MapTileType.road),
      MapTile(6, 37, MapTileType.subroom, txt: 'ライブラリ', right: 1, bottom: 1, left: 1),
      MapTile(2, 5, MapTileType.wc, wc: 0x1000), // 入口側トイレ男
      MapTile(2, 5, MapTileType.otherroom),
      MapTile(3, 2, MapTileType.otherroom),
      MapTile(42, 1, MapTileType.road, left: 1),
      MapTile(1, 6, MapTileType.road, left: 1),
      MapTile(3, 2, MapTileType.teacherroom, txt: '355'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '354'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '353'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '352'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '351'),
      MapTile(4, 4, MapTileType.wc, wc: 0x1101), // 331側トイレ
      MapTile(2, 6, MapTileType.road),
      MapTile(2, 2, MapTileType.teacherroom, txt: '350'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '349'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '348'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '347'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '346'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '345'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '344'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '343'),
      MapTile(2, 2, MapTileType.teacherroom, txt: '342'),
      MapTile(4, 2, MapTileType.wc, wc: 0x0110), // 入口側トイレ女
      MapTile(2, 6, MapTileType.road),
      MapTile(1, 4, MapTileType.otherroom),
      MapTile(2, 4, MapTileType.teacherroom, txt: '335'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '334'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '333'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '332'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '331'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '330'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '329'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '328'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '327'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '326'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '325'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '324'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '323'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '322'),
      MapTile(2, 4, MapTileType.subroom, txt: '321'),
      MapTile(4, 2, MapTileType.otherroom),
      MapTile(2, 4, MapTileType.otherroom),
      MapTile(42, 1, MapTileType.road, left: 1),
      MapTile(12, 5, MapTileType.otherroom, left: 1, bottom: 1),
      MapTile(4, 3, MapTileType.road),
      MapTile(2, 1, MapTileType.road),
      MapTile(2, 2, MapTileType.otherroom),
      MapTile(1, 2, MapTileType.road),
      MapTile(14, 2, MapTileType.otherroom),
      MapTile(1, 2, MapTileType.road),
      MapTile(4, 3, MapTileType.road),
      MapTile(2, 1, MapTileType.road),
      MapTile(2, 4, MapTileType.stair,
          bottom: 1,
          left: 1,
          right: 1,
          stairType: const MapStairType(Axis.vertical, false, true)), // 階段331側下り
      MapTile(2, 4, MapTileType.stair,
          bottom: 1,
          left: 1,
          right: 1,
          stairType: const MapStairType(Axis.vertical, false, true)), // 階段321側下り
      MapTile(18, 3, MapTileType.road, bottom: 1),
      MapTile(2, 2, MapTileType.road, bottom: 1),
      MapTile(2, 2, MapTileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const MapStairType(Axis.horizontal, true, false)), // 階段331側上り
      MapTile(2, 2, MapTileType.road),
      MapTile(2, 2, MapTileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const MapStairType(Axis.horizontal, true, false)), // 階段321側上り
      MapTile(36, 12, MapTileType.empty, right: 1),
      MapTile(2, 12, MapTileType.road, bottom: 1),
      MapTile(4, 8, MapTileType.empty, left: 1),
      MapTile(2, 2, MapTileType.ev, left: 1, top: 1, right: 1), // エレベーター
      MapTile(2, 2, MapTileType.empty),
      MapTile(2, 1, MapTileType.road, right: 1, bottom: 1),
      MapTile(2, 1, MapTileType.empty),
      MapTile(4, 1, MapTileType.empty, left: 1),
    ],
    "4": [
      MapTile(12, 18, MapTileType.otherroom, txt: '体育館', top: 1, left: 1, bottom: 1, right: 1),
      //Tile(6, 6, TileType.empty, left: 1.5),  一応吹き抜けでトレーニングルーム見える
      MapTile(36, 6, MapTileType.empty),
      MapTile(2, 6, MapTileType.road, top: 1),
      MapTile(2, 4, MapTileType.wc, top: 1, right: 1, wc: 0x1110), // 体育館側トイレ
      MapTile(2, 6, MapTileType.empty, bottom: 1),
      MapTile(6, 6, MapTileType.classroom, txt: '495C&D', classroomNo: '9', top: 1, left: 1),
      MapTile(6, 6, MapTileType.classroom, txt: '494C&D', classroomNo: '8', top: 1),
      MapTile(6, 6, MapTileType.classroom, txt: '493', classroomNo: '3', top: 1),
      MapTile(2, 6, MapTileType.road, top: 1),
      MapTile(2, 6, MapTileType.road, top: 1, bottom: 1),
      MapTile(2, 2, MapTileType.subroom, top: 1, txt: '証明書発行機'),
      MapTile(6, 10, MapTileType.subroom, txt: '事務局', top: 1, right: 1),
      MapTile(2, 4, MapTileType.road),
      MapTile(2, 2, MapTileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const MapStairType(Axis.horizontal, true, true)), // 体育館側階段
      MapTile(26, 1, MapTileType.road),
      MapTile(2, 1, MapTileType.road, vendingMachine: 1),
      MapTile(2, 1, MapTileType.road),
      MapTile(2, 13, MapTileType.road),
      MapTile(2, 5, MapTileType.otherroom, right: 1, bottom: 1),
      MapTile(2, 5, MapTileType.empty, top: 1),
      MapTile(6, 5, MapTileType.classroom, txt: '485', left: 1, bottom: 1),
      MapTile(6, 5, MapTileType.classroom, txt: '484', classroomNo: '10', bottom: 1),
      MapTile(6, 5, MapTileType.classroom, txt: '483', classroomNo: '19', bottom: 1),
      MapTile(2, 13, MapTileType.road),
      MapTile(2, 5, MapTileType.wc, bottom: 1, wc: 0x1110), // 事務側トイレ
      MapTile(2, 5, MapTileType.stair,
          right: 1, bottom: 1, left: 1, stairType: const MapStairType(Axis.vertical, false, true)),
      MapTile(1, 2, MapTileType.road),
      MapTile(5, 2, MapTileType.subroom, txt: '局長室', right: 1, bottom: 1),
      MapTile(12, 6, MapTileType.empty, right: 1),
      MapTile(22, 2, MapTileType.empty, left: 1, right: 1),
      MapTile(4, 2, MapTileType.empty, left: 1, right: 1),
      MapTile(1, 8, MapTileType.road),
      MapTile(5, 6, MapTileType.empty, left: 1),
      MapTile(2, 2, MapTileType.stair, top: 1, right: 1, bottom: 1), // モール体育館側
      MapTile(18, 2, MapTileType.empty),
      MapTile(2, 2, MapTileType.ev, txt: 'ev', top: 1, bottom: 1, left: 1),
      MapTile(2, 2, MapTileType.stair, top: 1, right: 1, bottom: 1), // モール正面玄関側
      MapTile(2, 2, MapTileType.empty, right: 1),
      MapTile(22, 2, MapTileType.empty, left: 1, right: 1),
      MapTile(4, 2, MapTileType.empty, left: 1, right: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-15', top: 1, left: 1), //文字はみ出してる
      MapTile(2, 2, MapTileType.subroom, txt: 'S-14', top: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-13', top: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-12', top: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-11', top: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-10', top: 1),
      MapTile(1, 2, MapTileType.otherroom, top: 1),
      MapTile(1, 2, MapTileType.wc, wc: 0x0001, top: 1, right: 1),
      MapTile(2, 2, MapTileType.empty, bottom: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-9', top: 1, left: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-8', top: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-7', top: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-6', top: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-5', top: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-4', top: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-3', top: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-2', top: 1),
      MapTile(2, 2, MapTileType.subroom, txt: 'S-1', top: 1),
      MapTile(1, 2, MapTileType.otherroom, top: 1),
      MapTile(1, 2, MapTileType.otherroom, txt: '倉庫', top: 1, right: 1),
      MapTile(2, 2, MapTileType.empty, bottom: 1, right: 1),
      MapTile(2, 2, MapTileType.otherroom, top: 1),
      MapTile(3, 3, MapTileType.subroom, txt: '理事室', top: 1, right: 1),
      MapTile(43, 1, MapTileType.road, left: 1),
      MapTile(2, 5, MapTileType.subroom, txt: '秘書室'),
      MapTile(1, 4, MapTileType.road, left: 1),
      MapTile(1, 4, MapTileType.otherroom, txt: '倉庫'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '435'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '434'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '433'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '432'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '431'),
      MapTile(2, 4, MapTileType.road),
      MapTile(2, 3, MapTileType.wc, wc: 0x1100, right: 1),
      MapTile(2, 10, MapTileType.empty, top: 1),
      MapTile(1, 2, MapTileType.otherroom, txt: '印刷', left: 1),
      MapTile(1, 4, MapTileType.road),
      MapTile(2, 4, MapTileType.teacherroom, txt: '429'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '428'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '427'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '426'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '425'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '424'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '423'),
      MapTile(2, 4, MapTileType.subroom, txt: '422'),
      MapTile(2, 4, MapTileType.road),
      MapTile(2, 3, MapTileType.wc, wc: 0x1100, right: 1),
      MapTile(2, 10, MapTileType.empty, top: 1, right: 1),
      MapTile(1, 9, MapTileType.road),
      MapTile(3, 4, MapTileType.subroom, txt: '学長室', right: 1),
      MapTile(1, 2, MapTileType.otherroom, txt: '倉庫', left: 1),
      MapTile(2, 1, MapTileType.otherroom, right: 1),
      MapTile(2, 1, MapTileType.otherroom, right: 1),
      MapTile(14, 1, MapTileType.road, left: 1),
      MapTile(2, 3, MapTileType.subroom, txt: 'M402', right: 1),
      MapTile(22, 1, MapTileType.road, right: 1, left: 1),
      MapTile(5, 4, MapTileType.subroom, txt: '特別応接室', right: 1),
      MapTile(12, 5, MapTileType.otherroom, left: 1, bottom: 1),
      MapTile(2, 5, MapTileType.road),
      MapTile(18, 3, MapTileType.otherroom, left: 1),
      MapTile(2, 5, MapTileType.road),
      MapTile(2, 5, MapTileType.road, txt: 'ラウンジ', right: 1, bottom: 1),
      MapTile(2, 3, MapTileType.subroom, txt: 'M401', bottom: 1, right: 1),
      MapTile(6, 2, MapTileType.otherroom, bottom: 1, left: 1),
      MapTile(6, 2, MapTileType.classroom, txt: 'メタ学習ラボ', bottom: 1),
      MapTile(6, 2, MapTileType.otherroom, bottom: 1),
      MapTile(4, 1, MapTileType.otherroom),
      MapTile(1, 1, MapTileType.road, right: 1),
      MapTile(6, 1, MapTileType.road, right: 1),
      MapTile(12, 19, MapTileType.empty, right: 1),
      MapTile(2, 7, MapTileType.road),
      MapTile(22, 5, MapTileType.empty, left: 1, right: 1),
      MapTile(2, 7, MapTileType.road),
      MapTile(4, 5, MapTileType.empty, left: 1, right: 1),
      MapTile(1, 7, MapTileType.road),
      MapTile(3, 3, MapTileType.subroom, txt: 'サーバーコンピュータ事務室'),
      MapTile(2, 3, MapTileType.wc, wc: 0x1101, right: 1), // サーバーコンピュータ室側トイレ
      MapTile(5, 4, MapTileType.subroom, txt: 'サーバーコンピュータ室', right: 1),
      MapTile(2, 2, MapTileType.stair, top: 1, right: 1, bottom: 1),
      MapTile(20, 2, MapTileType.empty, bottom: 1, right: 1),
      MapTile(2, 2, MapTileType.stair, top: 1, right: 1, bottom: 1),
      MapTile(2, 2, MapTileType.empty, right: 1),
      MapTile(26, 1, MapTileType.road),
      MapTile(4, 8, MapTileType.empty, left: 1, right: 1),
      MapTile(6, 12, MapTileType.classroom,
          txt: '講堂', classroomNo: '1', top: 1, right: 1, bottom: 1),
      MapTile(4, 11, MapTileType.subroom, txt: 'デルタビスタ', right: 1, bottom: 1),
      MapTile(20, 11, MapTileType.empty, top: 1, right: 1),
      MapTile(2, 9, MapTileType.road),
      MapTile(2, 2, MapTileType.ev, left: 1, top: 1, right: 1),
      MapTile(2, 2, MapTileType.empty, right: 1, bottom: 1),
      MapTile(6, 2, MapTileType.road, bottom: 1)
    ],
    "5": [
      MapTile(14, 2, MapTileType.otherroom,
          top: 1, left: 1, innerWidget: subTile(9, mapCircle7To15TileList)), //サークル1
      MapTile(2, 10, MapTileType.otherroom,
          right: 1, top: 1, innerWidget: subTile(5, mapCircle6To1TileList)), //サークル3
      MapTile(32, 6, MapTileType.empty), //empty
      MapTile(14, 1, MapTileType.road, left: 1),
      MapTile(1, 14, MapTileType.road, left: 1),
      MapTile(11, 14, MapTileType.empty, top: 1, right: 1, bottom: 1, left: 1), //empty gym
      MapTile(2, 9, MapTileType.road),
      MapTile(2, 6, MapTileType.empty, bottom: 1), //empty
      MapTile(6, 6, MapTileType.classroom, txt: '595', classroomNo: '6', top: 1, left: 1),
      MapTile(6, 6, MapTileType.classroom, txt: '594', classroomNo: '5', top: 1),
      MapTile(6, 6, MapTileType.classroom, txt: '593', classroomNo: '4', top: 1, right: 1),
      MapTile(6, 6, MapTileType.empty, bottom: 1, right: 1), //吹き抜け
      MapTile(6, 12, MapTileType.subroom, top: 1, right: 1, bottom: 1, txt: '共同研究室'),
      MapTile(2, 2, MapTileType.stair,
          stairType: const MapStairType(Axis.horizontal, false, true),
          top: 1,
          right: 1,
          bottom: 1), // 階段体育館側
      MapTile(30, 1, MapTileType.road),
      MapTile(2, 4, MapTileType.road),
      MapTile(2, 5, MapTileType.wc, wc: 0x1110, right: 1, bottom: 1), // 体育館側トイレ
      MapTile(2, 5, MapTileType.empty, top: 1), //吹き抜け
      MapTile(6, 5, MapTileType.classroom, txt: '585', classroomNo: '13', left: 1, bottom: 1),
      MapTile(6, 5, MapTileType.classroom, txt: '584', classroomNo: '12', bottom: 1),
      MapTile(6, 5, MapTileType.classroom, txt: '583', classroomNo: '11', bottom: 1),
      MapTile(2, 5, MapTileType.road),
      MapTile(2, 5, MapTileType.wc, right: 1, bottom: 1, wc: 0x1100), // 事務側トイレ
      MapTile(2, 5, MapTileType.empty, top: 1, right: 1), //吹き抜け
      MapTile(14, 1, MapTileType.road, left: 1),
      MapTile(12, 6, MapTileType.empty, top: 1, bottom: 1, right: 1), //empty left
      MapTile(2, 6, MapTileType.road),
      MapTile(22, 2, MapTileType.empty, left: 1, right: 1), //empty center1
      MapTile(2, 6, MapTileType.road),
      MapTile(10, 2, MapTileType.empty, left: 1), //empty right1
      MapTile(2, 2, MapTileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const MapStairType(Axis.horizontal, false, true)), // 階段center側
      MapTile(18, 2, MapTileType.empty), //empty center2
      MapTile(2, 2, MapTileType.ev, top: 1, left: 1, bottom: 1), // エレベーターcenter
      MapTile(2, 2, MapTileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const MapStairType(Axis.horizontal, false, true)), // 階段right側
      MapTile(8, 2, MapTileType.empty), //empty right2
      MapTile(22, 2, MapTileType.empty, left: 1, right: 1, bottom: 1), //empty center3
      MapTile(10, 2, MapTileType.empty, left: 1), //empty right3
      MapTile(38, 1, MapTileType.road, left: 1),
      MapTile(2, 5, MapTileType.otherroom, top: 1, right: 1),
      MapTile(2, 5, MapTileType.empty, right: 1, bottom: 1), //吹き抜け
      MapTile(2, 5, MapTileType.road, top: 1),
      MapTile(4, 8, MapTileType.otherroom, top: 1, right: 1, txt: '会議室'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '536', left: 1),
      MapTile(2, 4, MapTileType.teacherroom, txt: '535'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '534'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '533'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '532'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '531'),
      MapTile(2, 4, MapTileType.road),
      MapTile(2, 4, MapTileType.otherroom, right: 1),
      MapTile(2, 4, MapTileType.empty, top: 1, bottom: 1), //吹き抜け
      MapTile(1, 4, MapTileType.wc, left: 1, wc: 0x0001),
      MapTile(1, 4, MapTileType.road),
      MapTile(2, 4, MapTileType.teacherroom, txt: '529'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '528'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '527'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '526'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '525'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '524'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '523'),
      MapTile(2, 4, MapTileType.teacherroom, txt: '522'),
      MapTile(2, 4, MapTileType.road),
      MapTile(44, 1, MapTileType.road, left: 1),
      MapTile(12, 2, MapTileType.otherroom, left: 1, bottom: 1), //スタジオleft
      MapTile(2, 2, MapTileType.road),
      MapTile(2, 2, MapTileType.subroom, right: 1, bottom: 1, txt: '大学生協学生委員室'),
      MapTile(2, 2, MapTileType.empty, top: 1), //吹き抜け
      MapTile(18, 2, MapTileType.otherroom, left: 1, bottom: 1), //スタジオcenter
      MapTile(2, 11, MapTileType.road),
      MapTile(2, 2, MapTileType.subroom, right: 1, bottom: 1, txt: 'M502'),
      MapTile(2, 2, MapTileType.empty, top: 1, right: 1), //吹き抜け
      MapTile(2, 4, MapTileType.road),
      MapTile(12, 12, MapTileType.empty, right: 1), //empty left
      MapTile(2, 12, MapTileType.road, bottom: 1),
      MapTile(22, 10, MapTileType.empty, left: 1, right: 1), //empty center
      MapTile(4, 9, MapTileType.empty, left: 1, right: 1, bottom: 1), //empty right
      MapTile(4, 2, MapTileType.subroom, right: 1, txt: 'M501'),
      MapTile(6, 2, MapTileType.road, right: 1),
      MapTile(1, 5, MapTileType.road),
      MapTile(4, 2, MapTileType.otherroom),
      MapTile(1, 5, MapTileType.road, right: 1),
      MapTile(4, 3, MapTileType.wc, wc: 0x1110), // 講堂側トイレ
      MapTile(12, 1, MapTileType.road, right: 1),
      MapTile(2, 2, MapTileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const MapStairType(Axis.horizontal, false, true)), // 階段center側
      MapTile(20, 2, MapTileType.empty, right: 1), //empty center
      MapTile(2, 2, MapTileType.road),
      MapTile(2, 2, MapTileType.stair,
          top: 1,
          right: 1,
          bottom: 1,
          stairType: const MapStairType(Axis.horizontal, false, true)), // 階段講堂側
      MapTile(2, 2, MapTileType.empty, top: 1, right: 1), //empty 階段横
      MapTile(1, 2, MapTileType.road),
      MapTile(4, 2, MapTileType.otherroom, txt: '調整室'), //調光室
      MapTile(1, 2, MapTileType.road, right: 1),
      MapTile(36, 12, MapTileType.empty, right: 1), //empty big1
      MapTile(2, 12, MapTileType.road, bottom: 1), //empty big1
      MapTile(4, 8, MapTileType.empty, left: 1, right: 1), //empty 講堂１
      MapTile(6, 12, MapTileType.classroom, txt: '講堂', right: 1, bottom: 1),
      MapTile(2, 2, MapTileType.ev, left: 1, top: 1, right: 1), // エレベーター
      MapTile(2, 2, MapTileType.empty, right: 1), //empty ev横
      MapTile(2, 1, MapTileType.road, right: 1, bottom: 1), //ev下
      MapTile(2, 1, MapTileType.empty, right: 1), //empty ev右下
      MapTile(4, 1, MapTileType.empty, left: 1, right: 1), //empty ev下
      MapTile(42, 7, MapTileType.empty), //empty ev横
      MapTile(6, 7, MapTileType.empty), //empty
    ],
    "R6": [
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R611', top: 1, left: 1),
      MapTile(1, 30, MapTileType.road, top: 1, bottom: 1),
      MapTile(3, 3, MapTileType.otherroom, top: 1),
      MapTile(3, 3, MapTileType.subroom, top: 1, txt: 'R627'),
      MapTile(2, 30, MapTileType.road, top: 1, bottom: 1),
      MapTile(4, 4, MapTileType.subroom, top: 1, txt: 'R637'),
      MapTile(4, 14, MapTileType.road, top: 1),
      MapTile(1, 24, MapTileType.road, top: 1),
      MapTile(4, 2, MapTileType.subroom, txt: 'R657', top: 1, right: 1),
      MapTile(22, 30, MapTileType.empty),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R610', left: 1),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R656', right: 1),
      MapTile(6, 1, MapTileType.road),
      MapTile(4, 2, MapTileType.road, left: 1),
      MapTile(3, 20, MapTileType.otherroom),
      MapTile(3, 4, MapTileType.subroom, txt: 'R626'),
      MapTile(4, 4, MapTileType.subroom, txt: 'R636'),
      MapTile(4, 2, MapTileType.road, right: 1),
      MapTile(4, 2, MapTileType.stair,
          left: 1, top: 1, bottom: 1, stairType: const MapStairType(Axis.horizontal, true, false)),
      MapTile(4, 2, MapTileType.stair,
          right: 1, top: 1, bottom: 1, stairType: const MapStairType(Axis.horizontal, true, false)),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R609', left: 1),
      MapTile(3, 4, MapTileType.subroom, txt: 'R625'),
      MapTile(4, 3, MapTileType.subroom, txt: 'R635'),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R655', right: 1),
      MapTile(4, 2, MapTileType.teacherroom, left: 1, txt: 'R608'),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R654', right: 1),
      MapTile(4, 3, MapTileType.subroom, txt: 'R634'),
      MapTile(4, 2, MapTileType.teacherroom, left: 1, txt: 'R607'),
      MapTile(3, 4, MapTileType.subroom, txt: 'R624'),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R653', right: 1),
      MapTile(4, 2, MapTileType.subroom, txt: 'R606', left: 1),
      MapTile(4, 2, MapTileType.subroom, txt: 'R633'),
      MapTile(4, 2, MapTileType.otherroom),
      MapTile(4, 2, MapTileType.subroom, right: 1, txt: 'R652'),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R605', left: 1),
      MapTile(3, 4, MapTileType.subroom, txt: 'R623'),
      MapTile(4, 4, MapTileType.subroom, txt: 'R632'),
      MapTile(4, 4, MapTileType.subroom, txt: 'R642'),
      MapTile(4, 6, MapTileType.subroom, right: 1, txt: 'R651'),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R604', left: 1),
      MapTile(4, 2, MapTileType.stair,
          left: 1, top: 1, bottom: 1, stairType: const MapStairType(Axis.horizontal, true, false)),
      MapTile(3, 4, MapTileType.subroom, txt: 'R622'),
      MapTile(8, 2, MapTileType.road),
      MapTile(4, 2, MapTileType.road, left: 1),
      MapTile(4, 4, MapTileType.subroom, txt: 'R631'),
      MapTile(2, 2, MapTileType.ev),
      MapTile(2, 2, MapTileType.stair,
          left: 1, right: 1, bottom: 1, stairType: const MapStairType(Axis.vertical, true, false)),
      MapTile(4, 2, MapTileType.otherroom, right: 1),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R603', left: 1),
      MapTile(6, 1, MapTileType.road),
      MapTile(5, 4, MapTileType.subroom, txt: 'R641', right: 1),
      MapTile(4, 6, MapTileType.empty, top: 1),
      MapTile(3, 5, MapTileType.otherroom, bottom: 1),
      MapTile(3, 3, MapTileType.subroom, txt: 'R621'),
      MapTile(4, 2, MapTileType.subroom, txt: 'R602', left: 1),
      MapTile(4, 4, MapTileType.wc, wc: 0x1110, bottom: 1),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R601', left: 1, bottom: 1),
      MapTile(2, 2, MapTileType.otherroom, bottom: 1),
      MapTile(1, 2, MapTileType.otherroom, bottom: 1),
      MapTile(4, 2, MapTileType.subroom, bottom: 1),
      MapTile(1, 2, MapTileType.subroom, bottom: 1, right: 1),
    ],
    "R7": [
      MapTile(4, 2, MapTileType.subroom, txt: 'R711', top: 1, left: 1),
      MapTile(1, 30, MapTileType.road, top: 1, bottom: 1),
      MapTile(3, 3, MapTileType.empty, bottom: 1, left: 1),
      MapTile(2, 3, MapTileType.otherroom, left: 1, top: 1, right: 1),
      MapTile(3, 3, MapTileType.empty, bottom: 1),
      MapTile(2, 3, MapTileType.empty),
      MapTile(2, 9, MapTileType.otherroom, left: 1, top: 1, right: 1),
      MapTile(4, 9, MapTileType.empty, right: 1, bottom: 1),
      MapTile(1, 14, MapTileType.road, top: 1),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R757', top: 1, right: 1),
      MapTile(22, 20, MapTileType.empty, bottom: 1),
      MapTile(4, 2, MapTileType.subroom, txt: 'R710', left: 1),
      MapTile(4, 2, MapTileType.teacherroom, txt: 'R756', right: 1),
      MapTile(6, 1, MapTileType.road),
      MapTile(2, 22, MapTileType.road),
      MapTile(2, 6, MapTileType.empty, left: 1, bottom: 1),
      MapTile(4, 2, MapTileType.road, left: 1),
      MapTile(6, 4, MapTileType.empty, left: 1, top: 1, right: 1),
      MapTile(4, 2, MapTileType.road, right: 1),
      MapTile(4, 2, MapTileType.stair,
          left: 1, top: 1, bottom: 1, stairType: const MapStairType(Axis.horizontal, false, true)),
      MapTile(4, 2, MapTileType.stair,
          right: 1, top: 1, bottom: 1, stairType: const MapStairType(Axis.horizontal, false, true)),
      MapTile(4, 2, MapTileType.subroom, txt: 'R709', left: 1),
      MapTile(4, 12, MapTileType.empty, left: 1),
      MapTile(2, 4, MapTileType.subroom, txt: 'R725', left: 1, top: 1),
      MapTile(4, 2, MapTileType.subroom, txt: 'R755', right: 1),
      MapTile(8, 1, MapTileType.road),
      MapTile(4, 4, MapTileType.otherroom, left: 1),
      MapTile(8, 4, MapTileType.empty, left: 1, top: 1, right: 1, bottom: 1),
      MapTile(4, 2, MapTileType.subroom, txt: 'R754', right: 1),
      MapTile(2, 4, MapTileType.subroom, txt: 'R724', left: 1),
      MapTile(4, 2, MapTileType.subroom, txt: 'R753', right: 1),
      MapTile(4, 2, MapTileType.subroom, txt: 'R706', left: 1),
      MapTile(2, 2, MapTileType.otherroom),
      MapTile(2, 2, MapTileType.otherroom),
      MapTile(9, 6, MapTileType.otherroom, right: 1),
      MapTile(4, 2, MapTileType.subroom, txt: 'R705', left: 1),
      MapTile(2, 4, MapTileType.subroom, txt: 'R723', left: 1, bottom: 1),
      MapTile(4, 4, MapTileType.subroom, txt: 'R731'),
      MapTile(4, 2, MapTileType.subroom, txt: 'R704', left: 1),
      MapTile(4, 2, MapTileType.stair,
          left: 1, top: 1, bottom: 1, stairType: const MapStairType(Axis.horizontal, false, true)),
      MapTile(6, 4, MapTileType.empty, left: 1, bottom: 1, right: 1),
      MapTile(30, 2, MapTileType.road),
      MapTile(5, 10, MapTileType.classroom, txt: 'R791', right: 1, bottom: 1, classroomNo: '7'),
      MapTile(4, 2, MapTileType.road, left: 1),
      MapTile(3, 3, MapTileType.empty, left: 1, top: 1, right: 1),
      MapTile(1, 7, MapTileType.road),
      MapTile(2, 2, MapTileType.ev),
      MapTile(2, 2, MapTileType.stair,
          left: 1, right: 1, stairType: const MapStairType(Axis.vertical, false, true)),
      MapTile(1, 2, MapTileType.otherroom),
      MapTile(4, 2, MapTileType.subroom, txt: 'R751'),
      MapTile(5, 2, MapTileType.otherroom),
      MapTile(4, 8, MapTileType.classroom, txt: 'R781', classroomNo: '14', bottom: 1),
      MapTile(4, 8, MapTileType.classroom, txt: 'R782', classroomNo: '15', bottom: 1),
      MapTile(2, 2, MapTileType.ev),
      MapTile(2, 2, MapTileType.road),
      MapTile(4, 2, MapTileType.subroom, txt: 'R703', left: 1),
      MapTile(6, 1, MapTileType.road),
      MapTile(5, 4, MapTileType.empty, top: 1, left: 1),
      MapTile(9, 6, MapTileType.empty, right: 1, top: 1),
      MapTile(4, 2, MapTileType.road),
      MapTile(3, 5, MapTileType.empty, top: 1, left: 1),
      MapTile(2, 5, MapTileType.otherroom, bottom: 1, left: 1),
      MapTile(3, 3, MapTileType.empty, left: 1, top: 1),
      MapTile(3, 1, MapTileType.empty, right: 1),
      MapTile(4, 2, MapTileType.subroom, txt: 'R702', left: 1),
      MapTile(3, 4, MapTileType.wc, left: 1, top: 1, bottom: 1, wc: 0x1100),
      MapTile(1, 2, MapTileType.stair,
          right: 1, bottom: 1, left: 1, stairType: const MapStairType(Axis.vertical, true, false)),
      MapTile(1, 2, MapTileType.road),
      MapTile(2, 2, MapTileType.wc, wc: 0x0010),
      MapTile(4, 2, MapTileType.subroom, txt: 'R701', left: 1, bottom: 1),
      MapTile(1, 2, MapTileType.otherroom, right: 1, top: 1, bottom: 1),
      MapTile(2, 2, MapTileType.empty),
      MapTile(5, 2, MapTileType.otherroom, bottom: 1, right: 1, top: 1),
      MapTile(2, 2, MapTileType.wc, bottom: 1, wc: 0x0100),
      MapTile(2, 2, MapTileType.wc, bottom: 1, wc: 0x1000),
      MapTile(1, 1, MapTileType.wc, bottom: 1),
    ],
  };

  static final List<MapTile> mapCircle7To15TileList = [
    MapTile(1, 1, MapTileType.subroom, txt: 'サークル室15'),
    MapTile(1, 1, MapTileType.subroom, txt: 'サークル室14'),
    MapTile(1, 1, MapTileType.subroom, txt: 'サークル室13'),
    MapTile(1, 1, MapTileType.subroom, txt: 'サークル室12'),
    MapTile(1, 1, MapTileType.subroom, txt: 'サークル室11'),
    MapTile(1, 1, MapTileType.subroom, txt: 'サークル室10'),
    MapTile(1, 1, MapTileType.subroom, txt: 'サークル室9'),
    MapTile(1, 1, MapTileType.subroom, txt: 'サークル室8'),
    MapTile(1, 1, MapTileType.subroom, txt: 'サークル室7'),
  ];

  static final List<MapTile> mapCircle6To1TileList = [
    MapTile(5, 8, MapTileType.subroom, txt: 'サークル室6', fontSize: 3),
    MapTile(5, 4, MapTileType.subroom, txt: 'サークル室5', fontSize: 3),
    MapTile(5, 4, MapTileType.subroom, txt: 'サークル室4', fontSize: 3),
    MapTile(5, 4, MapTileType.subroom, txt: 'サークル室3', fontSize: 3),
    MapTile(5, 4, MapTileType.subroom, txt: 'サークル室2', fontSize: 3),
    MapTile(5, 4, MapTileType.subroom, txt: 'サークル室1', fontSize: 3),
  ];

  static Widget subTile(int count, List<MapTile> tileList) {
    return StaggeredGrid.count(
      crossAxisCount: count,
      children: [
        ...tileList.map(
          (e) {
            return StaggeredGridTile.count(
                crossAxisCellCount: e.width, mainAxisCellCount: e.height, child: e);
          },
        )
      ],
    );
  }
}
