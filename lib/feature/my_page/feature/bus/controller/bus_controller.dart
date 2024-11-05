import 'dart:async';

import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/feature/my_page/feature/bus/domain/bus_stop.dart';
import 'package:dotto/feature/my_page/feature/bus/domain/bus_trip.dart';
import 'package:dotto/feature/my_page/feature/bus/repository/bus_repository.dart';
import 'package:dotto/importer.dart';

final allBusStopsProvider =
    NotifierProvider<AllBusStopsNotifier, List<BusStop>?>(() => AllBusStopsNotifier());

class AllBusStopsNotifier extends Notifier<List<BusStop>?> {
  @override
  List<BusStop>? build() {
    return null;
  }

  Future<void> init() async {
    state = await BusRepository().getAllBusStopsFromFirebase();
  }
}

/// Map<String, Map<String, List<BusTrip>>>
/// 1つ目のStringキー: from_fun, to_fun
/// 2つ目のStringキー: holiday, weekday
final busDataProvider = NotifierProvider<BusDataNotifier, Map<String, Map<String, List<BusTrip>>>?>(
    () => BusDataNotifier());

class BusDataNotifier extends Notifier<Map<String, Map<String, List<BusTrip>>>?> {
  @override
  Map<String, Map<String, List<BusTrip>>>? build() {
    return null;
  }

  Future<void> init() async {
    final allBusStop = ref.watch(allBusStopsProvider);
    if (allBusStop != null) {
      state = await BusRepository().getBusDataFromFirebase(allBusStop);
    } else {
      await init();
    }
  }
}

final myBusStopProvider = NotifierProvider<MyBusStopNotifier, BusStop>(() {
  return MyBusStopNotifier();
});

class MyBusStopNotifier extends Notifier<BusStop> {
  @override
  BusStop build() {
    return const BusStop(
        14013, "亀田支所前", ["50", "55", "55A", "55B", "55C", "55E", "55F", "55G", "55H"]);
  }

  Future<void> init() async {
    final myBusStopPreference = await UserPreferences.getInt(UserPreferenceKeys.myBusStop);
    final allBusStop = ref.watch(allBusStopsProvider);
    if (allBusStop != null) {
      state = allBusStop.firstWhere((busStop) => busStop.id == (myBusStopPreference ?? 14013));
    } else {
      await init();
    }
  }

  void set(BusStop myBusStop) {
    state = myBusStop;
  }
}

final busIsToProvider = NotifierProvider<BusIsToNotifier, bool>(() => BusIsToNotifier());

class BusIsToNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void change() {
    state = !state;
  }
}

final busRefreshProvider =
    NotifierProvider<BusRefreshNotifier, DateTime>(() => BusRefreshNotifier());

class BusRefreshNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void start() {
    Timer.periodic(const Duration(seconds: 30), (_) async {
      state = DateTime.now();
    });
  }
}

final busIsWeekdayNotifier =
    NotifierProvider<BusIsWeekdayNotifier, bool>(() => BusIsWeekdayNotifier());

class BusIsWeekdayNotifier extends Notifier<bool> {
  @override
  bool build() {
    final now = DateTime.now().weekday;
    return now <= 5;
  }

  void change() {
    state = !state;
  }
}

final busScrolledProvider = StateProvider<bool>((ref) => false);
