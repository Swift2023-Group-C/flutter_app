import 'package:dotto/feature/my_page/feature/bus/domain/bus_stop.dart';
import 'package:dotto/feature/my_page/feature/bus/domain/bus_trip.dart';
import 'package:dotto/repository/get_firebase_realtime_db.dart';

class BusRepository {
  static final BusRepository _instance = BusRepository._internal();
  factory BusRepository() {
    return _instance;
  }
  BusRepository._internal();

  Future<List<BusStop>> getAllBusStopsFromFirebase() async {
    final snapshot = await GetFirebaseRealtimeDB.getData('bus/stops'); //firebaseから情報取得
    if (snapshot.exists) {
      final busDataStops = snapshot.value as List;
      return busDataStops.map((e) => BusStop.fromFirebase(e)).toList();
    } else {
      throw Exception();
    }
  }

  Future<Map<String, Map<String, List<BusTrip>>>> getBusDataFromFirebase(
      List<BusStop> allBusStops) async {
    final snapshot = await GetFirebaseRealtimeDB.getData('bus/trips'); //firebaseから情報取得
    if (snapshot.exists) {
      final busTripsData = snapshot.value as Map;
      Map<String, Map<String, List<BusTrip>>> allBusTrips = {
        "from_fun": {"holiday": [], "weekday": []},
        "to_fun": {"holiday": [], "weekday": []}
      };
      busTripsData.forEach(
        (key, value) {
          final String fromTo = key;
          (value as Map).forEach((key2, value2) {
            final String week = key2;
            allBusTrips[fromTo]![week] = (value2 as List)
                .map((e) => BusTrip.fromFirebase(value2 as Map, allBusStops))
                .toList();
          });
        },
      );
      return allBusTrips;
    } else {
      throw Exception();
    }
  }
}
