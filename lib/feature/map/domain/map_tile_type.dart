import 'package:dotto/importer.dart';

enum TileType {
  /// 講義室
  classroom(
    backgroundColor: Color(0xFF616161),
    textColor: Colors.white,
  ),

  /// 教員室と後ろの実験室
  teacherroom(
    backgroundColor: Color(0xFF757575),
    textColor: Colors.white,
  ),

  /// メインには使わないけど使う部屋
  subroom(
    backgroundColor: Colors.grey,
    textColor: Colors.white,
  ),

  /// 倉庫など
  otherroom(
    backgroundColor: Color(0xFFBDBDBD),
    textColor: Colors.white,
  ),

  /// トイレ
  wc(
    backgroundColor: Color(0xFF9CCC65),
    textColor: Colors.black,
  ),

  /// 階段
  stair(
    backgroundColor: Color(0xFFE0E0E0),
    textColor: Colors.black,
  ),

  /// エレベーター
  ev(
    backgroundColor: Color(0xFF424242),
    textColor: Colors.white,
  ),

  /// 道
  road(
    backgroundColor: Color(0xFFE0E0E0),
    textColor: Colors.black,
  ),

  /// 吹き抜けなど
  empty(
    backgroundColor: Colors.transparent,
    textColor: Colors.black,
  );

  const TileType({
    required this.backgroundColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color textColor;
}
