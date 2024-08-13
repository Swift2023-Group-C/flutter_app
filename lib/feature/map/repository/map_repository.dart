import 'dart:convert';

import 'package:dotto/repository/app_status.dart';

import 'package:dotto/importer.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/repository/get_firebase_realtime_db.dart';
import 'package:dotto/repository/read_json_file.dart';

class MapRepository {
  static final MapRepository _instance = MapRepository._internal();
  factory MapRepository() {
    return _instance;
  }
  MapRepository._internal();

  Future<Map<String, Map<String, MapDetail>>> getMapDetailMapFromFirebase() async {
    final snapshot = await GetFirebaseRealtimeDB.getData('map'); //firebaseから情報取得
    final snapshotRoom = await GetFirebaseRealtimeDB.getData('map_room_schedule'); //firebaseから情報取得
    Map<String, Map<String, MapDetail>> returnList = {
      '1': {},
      '2': {},
      '3': {},
      '4': {},
      '5': {},
      'R6': {},
      'R7': {}
    };
    if (snapshot.exists && snapshotRoom.exists) {
      (snapshot.value as Map).forEach((floor, value) {
        (value as Map).forEach((roomName, value2) {
          returnList[floor]!.addAll(
              {roomName: MapDetail.fromFirebase(floor, roomName, value2, (snapshotRoom as Map))});
        });
      });
    } else {
      debugPrint('No Map data available.');
      throw Exception();
    }
    return returnList;
  }

  Map<String, DateTime> findRoomsInUse(String jsonString, DateTime dateTime) {
    var decodedData = jsonDecode(jsonString);

    // JSONデータがリストでない場合はエラー
    if (decodedData is! List) {
      throw Exception("Expected a list of JSON objects");
    }

    Map<String, DateTime> resourceIds = {};

    for (var item in decodedData) {
      if (item is Map<String, dynamic>) {
        // スタート時間・エンド時間をDateTimeにかえる
        // スタートを10分前から
        DateTime startTime = DateTime.parse(item['start']).add(const Duration(minutes: -10));
        DateTime endTime = DateTime.parse(item['end']);

        //現在時刻が開始時刻と終了時刻の間であればresourceIdを取得
        if (dateTime.isAfter(startTime) && dateTime.isBefore(endTime)) {
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

  Future<Map<String, DateTime>> getUsingRoom(DateTime dateTime) async {
    String scheduleFilePath = 'map/oneweek_schedule.json';
    Map<String, DateTime> resourceIds = {};
    try {
      String fileContent = await readJsonFile(scheduleFilePath);
      resourceIds = findRoomsInUse(fileContent, dateTime);
    } catch (e) {
      debugPrint(e.toString());
    }
    return resourceIds;
  }

//使用されているかどうかで色を変える設定をする
  Future<Map<String, bool>> setUsingColor(DateTime dateTime) async {
    if (!AppStatus().isLoggedinGoogle) {
      return {};
    }
    final Map<String, bool> classroomNoFloorMap = {
      "1": false,
      "2": false,
      "3": false,
      "4": false,
      "5": false,
      "6": false,
      "7": false,
      "8": false,
      "9": false,
      "10": false,
      "11": false,
      "12": false,
      "13": false,
      "14": false,
      "15": false,
      "16": false,
      "17": false,
      "18": false,
      "19": false,
      "50": false,
      "51": false
    };

    Map<String, DateTime> resourceIds = await MapRepository().getUsingRoom(dateTime);
    if (resourceIds.isNotEmpty) {
      resourceIds.forEach((String resourceId, DateTime useEndTime) {
        debugPrint(resourceId);
        if (classroomNoFloorMap.containsKey(resourceId)) {
          classroomNoFloorMap[resourceId] = true;
        }
      });
    }
    return classroomNoFloorMap;
  }
}
