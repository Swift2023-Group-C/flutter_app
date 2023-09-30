class Kadai {
  Kadai(
    this.id,
    this.course,
    this.name,
    this.url,
    this.starttime,
    this.endtime,
  );
  final int? id;
  final String? course;
  final String? name;
  final String? url;
  final DateTime? starttime;
  final DateTime? endtime;

  factory Kadai.fromFirebase(String id, Map data) {
    return Kadai(
        int.parse(id),
        data["course"],
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
