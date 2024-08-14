import 'package:dotto/feature/my_page/feature/bus/domain/bus_stop.dart';

class BusTripStop {
  final Duration time;
  final BusStop stop;
  const BusTripStop(this.time, this.stop);

  factory BusTripStop.fromFirebase(BusStop stop, String timeString) {
    final timeStrList = timeString.split(":");
    final hour = int.parse(timeStrList[0]);
    final minute = int.parse(timeStrList[1]);
    return BusTripStop(Duration(hours: hour, minutes: minute), stop);
  }
}

class BusTrip {
  final String route;
  final List<BusTripStop> stops;

  const BusTrip(this.route, this.stops);

  factory BusTrip.fromFirebase(Map map, List<BusStop> allStops) {
    final List stopsList = map["stops"] as List;
    return BusTrip(map["route"], stopsList.map((e) {
          final int id = e["id"];
          final targetBusStop = allStops.firstWhere((busStop) => busStop.id == id);
          return BusTripStop.fromFirebase(targetBusStop, e["time"]);
        },).toList());
  }
}