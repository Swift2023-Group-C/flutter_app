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

  static const MapDetail none =
      MapDetail('1', '0', null, '0', null, null, null);
}

class MapDetailMap {
  final Map<String, Map<String, MapDetail>> mapDetailList;

  MapDetailMap(this.mapDetailList);

  MapDetail? searchOnce(String floor, String roomName) {
    if (mapDetailList.containsKey(floor)) {
      if (mapDetailList[floor]!.containsKey(roomName)) {
        return mapDetailList[floor]![roomName]!;
      }
    }
    return null;
  }

  List<MapDetail> searchAll(String searchText) {
    List<MapDetail> results = [];
    List<MapDetail> results2 = [];
    List<MapDetail> results3 = [];
    List<MapDetail> results4 = [];
    mapDetailList.forEach((_, value) {
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
    return [...results, ...results2, ...results3, ...results4];
  }
}
