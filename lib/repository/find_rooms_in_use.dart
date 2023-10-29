import 'dart:convert';

import 'package:flutter/material.dart';

Map<String, DateTime> findRoomsInUse(String jsonString) {
  debugPrint("Start findRoomsInUse");
  var decodedData = jsonDecode(jsonString);

  // JSONデータがリストでない場合はエラー
  if (decodedData is! List) {
    throw Exception("Expected a list of JSON objects");
  }

  Map<String, DateTime> resourceIds = {};
  DateTime now = DateTime.now();

  for (var item in decodedData) {
    if (item is Map<String, dynamic>) {
      // スタート時間・エンド時間をDateTimeにかえる
      // スタートを10分前から
      DateTime startTime =
          DateTime.parse(item['start']).add(const Duration(minutes: -10));
      DateTime endTime = DateTime.parse(item['end']);
      debugPrint("mid findRoomsInUse");

      //現在時刻が開始時刻と終了時刻の間であればresourceIdを取得
      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        debugPrint("mid2 findRoomsInUse");
        if (resourceIds.containsKey(item['resourceId'])) {
          debugPrint(item['resourceId']);
          if (resourceIds[item['resourceId']]!.isBefore(endTime)) {
            resourceIds[item['resourceId']] = endTime;
          }
        } else {
          resourceIds.addAll({item['resourceId']: endTime});
        }
      }
    }
  }

  return resourceIds;
}
