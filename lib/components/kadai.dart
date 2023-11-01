class Kadai {
  Kadai(
    this.id,
    this.courseId,
    this.courseName,
    this.name,
    this.url,
    this.starttime,
    this.endtime,
  );
  final int? id;
  final int? courseId;
  final String? courseName;
  final String? name;
  final String? url;
  final DateTime? starttime;
  final DateTime? endtime;

  factory Kadai.fromFirebase(String id, Map data) {
    return Kadai(
        int.parse(id),
        data["course_id"],
        data["course_name"],
        data["name"],
        data["url"],
        data["starttime"] == 0
            ? null
            : DateTime.fromMillisecondsSinceEpoch(data["starttime"] * 1000),
        data["endtime"] == 0
            ? null
            : DateTime.fromMillisecondsSinceEpoch(data["endtime"] * 1000));
  }
}

class KadaiList {
  KadaiList(
    this.courseId,
    this.courseName,
    this.endtime,
    this.listKadai,
  );

  final int courseId;
  final String courseName;
  final DateTime? endtime;
  List<Kadai> listKadai;

  get kadaiList => null;

  bool isListLength1() {
    return listKadai.length == 1;
  }

  Kadai getKadaiFirst() {
    return listKadai.first;
  }

  //対象のリストに含まれないリスト作成
  List<Kadai> hiddenKadai(List<int> deleteList) {
    List<Kadai> returnList = [];
    for (var kadai in listKadai) {
      if (!deleteList.contains(kadai.id)) {
        returnList.add(kadai);
      }
    }
    return returnList;
  }
}
