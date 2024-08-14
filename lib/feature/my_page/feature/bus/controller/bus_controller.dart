import 'package:dotto/feature/my_page/feature/bus/domain/bus_stop.dart';
import 'package:dotto/feature/my_page/feature/bus/repository/bus_repository.dart';
import 'package:dotto/importer.dart';

final allBusStopsProvider = FutureProvider(
  (ref) async {
    return await BusRepository().getAllBusStopsFromFirebase();
  },
);

final busDataProvider = FutureProvider(
  (ref) async {
    return await BusRepository().getBusDataFromFirebase(
        ref.watch(allBusStopsProvider as AlwaysAliveProviderListenable<List<BusStop>>));
  },
);
