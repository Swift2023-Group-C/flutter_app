import 'package:dotto/importer.dart';

import 'package:dotto/repository/get_firebase_realtime_db.dart';

final StateProvider<Map<String, bool>> mapUsingMapProvider =
    StateProvider((ref) => {});
final onMapSearchProvider = StateProvider((ref) => false);
final StateProvider<List<MapDetail>> mapSearchListProvider =
    StateProvider((ref) => []);
final mapPageProvider = StateProvider((ref) => 2);
final textEditingControllerProvider =
    StateProvider((ref) => TextEditingController());
final mapSearchBarFocusProvider = StateProvider((ref) => FocusNode());
final mapFocusMapDetailProvider = StateProvider(
    (ref) => const MapDetail('1', '0', null, '0', null, null, null));
final mapViewTransformationControllerProvider =
    StateProvider((ref) => TransformationController(Matrix4.identity()));
final searchDatetimeProvider = StateProvider((ref) => DateTime.now());
final mapDetailMapProvider = StateProvider((ref) => MapDetailMap());

class MapDetail {
  final String floor;
  final String roomName;
  final int? classroomNo;
  final String header;
  final String? detail;
  final String? mail;
  final List<String>? searchWordList;
  const MapDetail(this.floor, this.roomName, this.classroomNo, this.header,
      this.detail, this.mail, this.searchWordList);
  factory MapDetail.fromFirebase(String floor, String roomName, Map value) {
    List<String>? sWordList;
    if (value.containsKey('searchWordList')) {
      sWordList = (value['searchWordList'] as String).split(',');
    }
    return MapDetail(floor, roomName, value['classroomNo'], value['header'],
        value['detail'], value['mail'], sWordList);
  }
}

class MapDetailMap {
  Map<String, Map<String, MapDetail>>? mapDetailList;

  MapDetailMap() {
    Future(() async {
      mapDetailList = await getMapDetailFromFirebase();
    });
  }

  Future<Map<String, Map<String, MapDetail>>> getMapDetailFromFirebase() async {
    final snapshot = await GetFirebaseRealtimeDB.getData('map');
    Map<String, Map<String, MapDetail>> returnList = {
      '1': {},
      '2': {},
      '3': {},
      '4': {},
      '5': {},
      'R6': {},
      'R7': {}
    };
    if (snapshot.exists) {
      (snapshot.value as Map).forEach((floor, value) {
        (value as Map).forEach((roomName, value2) {
          returnList[floor]!.addAll(
              {roomName: MapDetail.fromFirebase(floor, roomName, value2)});
        });
      });
    } else {
      debugPrint('No Map data available.');
      throw Exception();
    }
    return returnList;
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
    List<MapDetail> results4 = [];
    if (mapDetailList != null) {
      mapDetailList!.forEach((_, value) {
        for (var mapDetail in value.values) {
          if (mapDetail.roomName == searchText) {
            results.add(mapDetail);
            continue;
          }
          if (mapDetail.searchWordList != null) {
            bool matchFlag = false;
            for (var word in mapDetail.searchWordList!) {
              if (word.contains(searchText)) {
                results2.add(mapDetail);
                matchFlag = true;
                break;
              }
            }
            if (matchFlag) continue;
          }
          if (mapDetail.header.contains(searchText)) {
            results3.add(mapDetail);
            continue;
          }
          if (mapDetail.mail != null) {
            if (mapDetail.mail!.contains(searchText)) {
              results3.add(mapDetail);
              continue;
            }
          }
          if (mapDetail.detail != null) {
            if (mapDetail.detail!.contains(searchText)) {
              results4.add(mapDetail);
              continue;
            }
          }
        }
      });
    }
    return [...results, ...results2, ...results3, ...results4];
  }
}
