import 'package:dotto/feature/my_page/feature/bus/repository/bus_repository.dart';
import 'package:dotto/importer.dart';

final allBusStopsProvider = FutureProvider(
  (ref) async {
    return await BusRepository().getAllBusStopsFromFirebase();
  },
);

final busDataProvider = FutureProvider(
  (ref) async {
    final allBusStop = await ref.watch(allBusStopsProvider.future);
    return await BusRepository().getBusDataFromFirebase(allBusStop);
  },
);
