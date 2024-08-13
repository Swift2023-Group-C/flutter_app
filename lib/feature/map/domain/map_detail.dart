class MapDetail {
  final String floor;
  final String roomName;
  final int? classroomNo;
  final String header;
  final String? detail;
  final List<RoomSchedule>? scheduleList;
  final String? mail;
  final List<String>? searchWordList;

  const MapDetail(this.floor, this.roomName, this.classroomNo, this.header, this.detail, this.mail,
      this.searchWordList,
      {this.scheduleList});

  factory MapDetail.fromFirebase(String floor, String roomName, Map value, Map roomScheduleMap) {
    List<String>? sWordList;
    if (value.containsKey('searchWordList')) {
      sWordList = (value['searchWordList'] as String).split(',');
    }
    List<RoomSchedule>? roomScheduleList;
    if (roomScheduleMap.containsKey(roomName)) {
      List scheduleList = roomScheduleMap[roomName] as List;
      roomScheduleList = scheduleList.map((e) {
        return RoomSchedule.fromFirebase(e);
      }).toList();
      roomScheduleList.sort(
        (a, b) {
          return a.begin.compareTo(b.begin);
        },
      );
    }
    return MapDetail(floor, roomName, value['classroomNo'], value['header'], value['detail'],
        value['mail'], sWordList,
        scheduleList: roomScheduleList);
  }

  static const MapDetail none = MapDetail('1', '0', null, '0', null, null, null);

  List<RoomSchedule> getScheduleListByDate(DateTime dateTime) {
    final list = scheduleList;
    if (list == null) {
      return [];
    }
    final targetDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final targetTomorrowDay = targetDay.add(const Duration(days: 1));
    return list
        .where((roomSchedule) =>
            roomSchedule.begin.isBefore(targetTomorrowDay) && roomSchedule.end.isAfter(targetDay))
        .toList();
  }
}

class RoomSchedule {
  final DateTime begin;
  final DateTime end;
  final String title;

  const RoomSchedule(this.begin, this.end, this.title);

  factory RoomSchedule.fromFirebase(Map map) {
    final beginDatetime = DateTime.parse(map['begin_datetime']);
    final endDatetime = DateTime.parse(map['end_datetime']);
    final title = map['title'];
    return RoomSchedule(beginDatetime, endDatetime, title);
  }
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
