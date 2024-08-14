class BusStop {
  final int id;
  final String name;
  // final List<String> routeList;

  const BusStop(this.id, this.name);

  factory BusStop.fromFirebase(Map map) {
    return BusStop(map["id"], map["name"]);
  }
}
