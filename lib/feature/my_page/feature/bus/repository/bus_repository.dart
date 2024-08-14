import 'package:dotto/feature/my_page/feature/bus/domain/bus_stop.dart';
import 'package:dotto/feature/my_page/feature/bus/domain/bus_trip.dart';
import 'package:dotto/repository/get_firebase_realtime_db.dart';

class BusRepository {
  static final BusRepository _instance = BusRepository._internal();
  factory BusRepository() {
    return _instance;
  }
  BusRepository._internal();

  String formatDuration(Duration d) {
    String twoDigits(int n) {
      if (n.isNaN) return "00";
      return n.toString().padLeft(2, "0").substring(0, 2);
    }

    // 符号の取得
    String negativeSign = d.isNegative ? '-' : '';

    // 各値の絶対値を取得
    int hour = d.inHours.abs();
    int min = d.inMinutes.remainder(60).abs();

    // 各値を2桁の文字列に変換
    String strHour = twoDigits(hour);
    String strMin = twoDigits(min);

    // フォーマット
    return "$negativeSign$strHour:$strMin";
  }

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
            allBusTrips[fromTo]![week] =
                (value2 as List).map((e) => BusTrip.fromFirebase(e as Map, allBusStops)).toList();
          });
        },
      );
      return allBusTrips;
    } else {
      throw Exception();
    }
  }
}
