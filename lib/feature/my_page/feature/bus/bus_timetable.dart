import 'package:dotto/feature/my_page/feature/bus/controller/bus_controller.dart';
import 'package:dotto/feature/my_page/feature/bus/domain/bus_trip.dart';
import 'package:dotto/feature/my_page/feature/bus/repository/bus_repository.dart';
import 'package:dotto/importer.dart';

class BusTimetableScreen extends ConsumerWidget {
  final BusTrip busTrip;
  const BusTimetableScreen(this.busTrip, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBusStops = ref.watch(allBusStopsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(busTrip.route),
      ),
      body: allBusStops.when(
        data: (data) {
          return ListView(
            children: busTrip.stops
                .map((busTripStop) => ListTile(
                      title: Text(busTripStop.stop.name),
                      subtitle: Text(BusRepository().formatDuration(busTripStop.time)),
                    ))
                .toList(),
          );
        },
        error: (error, stackTrace) => Column(
          children: [
            Text(error.toString()),
            Text(stackTrace.toString()),
          ],
        ),
        loading: () => const Center(
          child: Text("Loading"),
        ),
      ),
    );
  }
}
