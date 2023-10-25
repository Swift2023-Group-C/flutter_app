import 'package:flutter_app/repository/get_firebase_realtime_db.dart';

class MapDetail {
  final String floor;
  final String roomName;
  final int? classroomNo;
  final String header;
  final String? detail;
  final String? mail;
  const MapDetail(this.floor, this.roomName, this.classroomNo, this.header,
      this.detail, this.mail);
  factory MapDetail.fromFirebase(String floor, String roomName, Map value) {
    return MapDetail(floor, roomName, value['classroomNo'], value['header'],
        value['detail'], value['mail']);
  }
}

class MapDetailMap {
  Map<String, Map<String, MapDetail>>? mapDetailList;
  MapDetailMap._();
  static final instance = MapDetailMap._();

  Future<Map<String, Map<String, MapDetail>>> getMapDetailFromFirebase() async {
    final snapshot = await GetFirebaseRealtimeDB.getData('map');
    Map<String, Map<String, MapDetail>> returnList = {
      '1': {},
      '2': {},
      '3': {},
      '4': {},
      '5': {},
      'R1': {},
      'R2': {}
    };
    if (snapshot.exists) {
      (snapshot.value as Map).forEach((floor, value) {
        (value as Map).forEach((roomName, value2) {
          returnList[floor]!.addAll(
              {roomName: MapDetail.fromFirebase(floor, roomName, value2)});
        });
      });
    } else {
      print('No data available.');
      throw Exception();
    }
    return returnList;
  }

  Future<void> getList() async {
    try {
      mapDetailList = await getMapDetailFromFirebase();
    } catch (e) {
      mapDetailList = null;
    }
  }

  MapDetail? searchOnce(String floor, String roomName) {
    if (mapDetailList != null) {
      if (mapDetailList!.containsKey(floor)) {
        if (mapDetailList![floor]!.containsKey(roomName)) {
          return mapDetailList![floor]![roomName]!;
        }
      }
    }
    return null;
  }

  List<MapDetail> searchAll(String searchText) {
    List<MapDetail> results = [];
    List<MapDetail> results2 = [];
    List<MapDetail> results3 = [];
    if (mapDetailList != null) {
      mapDetailList!.forEach((_, value) {
        for (var mapDetail in value.values) {
          if (mapDetail.roomName == searchText) {
            results.add(mapDetail);
            continue;
          }
          if (searchText.length > 1) {
            if (mapDetail.header.contains(searchText)) {
              results2.add(mapDetail);
              continue;
            }
            if (mapDetail.mail != null) {
              if (mapDetail.mail!.contains(searchText)) {
                results2.add(mapDetail);
                continue;
              }
            }
            if (mapDetail.detail != null) {
              if (mapDetail.detail!.contains(searchText)) {
                results3.add(mapDetail);
                continue;
              }
            }
          }
        }
      });
    }
    return [...results, ...results2, ...results3];
  }
}
