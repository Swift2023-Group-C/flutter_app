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

class KadaiList extends Kadai {
  KadaiList(
    int? id,
    int? courseId,
    String? courseName,
    String? name,
    String? url,
    DateTime? starttime,
    DateTime? endtime,
    this.listKadai,
  ) : super(id, courseId, courseName, name, url, starttime, endtime);

  List<Kadai>? listKadai;

  factory KadaiList.fromListKadai(int courseId, String? courseName,
      DateTime? endtime, List<Kadai> listKadai) {
    return KadaiList(
        null, courseId, courseName, null, null, null, endtime, listKadai);
  }

  factory KadaiList.fromKadai(Kadai kadai) {
    return KadaiList(kadai.id, kadai.courseId, kadai.courseName, kadai.name,
        kadai.url, kadai.starttime, kadai.endtime, null);
  }
}
