class BusStop {
  final int id;
  final String name;
  final List<String> routeList;

  const BusStop(this.id, this.name, this.routeList);

  factory BusStop.fromFirebase(Map map) {
    final List<String> routeList = (map["route"] as List).map((e) => e.toString()).toList();
    return BusStop(map["id"], map["name"], routeList);
  }
}
