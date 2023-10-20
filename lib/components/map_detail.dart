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
    mapDetailList = await getMapDetailFromFirebase();
  }

  MapDetail? searchOnce(String floor, String roomName) {
    if (mapDetailList!.containsKey(floor)) {
      if (mapDetailList![floor]!.containsKey(roomName)) {
        return mapDetailList![floor]![roomName]!;
      }
    }
    return null;
  }
}
