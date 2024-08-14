import 'package:dotto/feature/my_page/feature/bus/repository/bus_repository.dart';
import 'package:dotto/importer.dart';

final allBusStopsProvider = FutureProvider(
  (ref) async {
    return await BusRepository().getAllBusStopsFromFirebase();
  },
);

/// Map<String, Map<String, List<BusTrip>>>
/// 1つ目のStringキー: from_fun, to_fun
/// 2つ目のStringキー: holiday, weekday
final busDataProvider = FutureProvider(
  (ref) async {
    final allBusStop = await ref.watch(allBusStopsProvider.future);
    return await BusRepository().getBusDataFromFirebase(allBusStop);
  },
);
