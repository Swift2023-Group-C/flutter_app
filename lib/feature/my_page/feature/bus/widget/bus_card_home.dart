import 'package:collection/collection.dart';
import 'package:dotto/components/animation.dart';
import 'package:dotto/feature/my_page/feature/bus/bus.dart';
import 'package:dotto/feature/my_page/feature/bus/controller/bus_controller.dart';
import 'package:dotto/feature/my_page/feature/bus/domain/bus_trip.dart';
import 'package:dotto/feature/my_page/feature/bus/widget/bus_card.dart';
import 'package:dotto/importer.dart';

class BusCardHome extends ConsumerWidget {
  const BusCardHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busData = ref.watch(busDataProvider);
    final myBusStop = ref.watch(myBusStopProvider);
    final busIsTo = ref.watch(busIsToProvider);
    final busRefresh = ref.watch(busRefreshProvider);
    final busIsWeekday = ref.watch(busIsWeekdayNotifier);

    String fromToString = busIsTo ? "to_fun" : "from_fun";

    return busData.when(
      data: (allData) {
        final data = allData[fromToString]![busIsWeekday ? "weekday" : "holiday"]!;
        for (var busTrip in data) {
          final funBusTripStop =
              busTrip.stops.firstWhereOrNull((element) => element.stop.id == 14023);
          if (funBusTripStop == null) {
            continue;
          }
          BusTripStop? targetBusTripStop =
              busTrip.stops.firstWhereOrNull((element) => element.stop.id == myBusStop.id);
          bool kameda = false;
          if (targetBusTripStop == null) {
            targetBusTripStop = busTrip.stops.firstWhere((element) => element.stop.id == 14013);
            kameda = true;
          }
          final fromBusTripStop = busIsTo ? targetBusTripStop : funBusTripStop;
          final toBusTripStop = busIsTo ? funBusTripStop : targetBusTripStop;
          final now = busRefresh;
          final nowDuration = Duration(hours: now.hour, minutes: now.minute);
          final arriveAt = fromBusTripStop.time - nowDuration;
          if (arriveAt.isNegative) {
            continue;
          }
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const BusScreen(),
                  transitionsBuilder: fromRightAnimation,
                ),
              );
            },
            child: BusCard(busTrip.route, fromBusTripStop.time, toBusTripStop.time, arriveAt,
                isKameda: kameda, home: true),
          );
        }
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BusScreen(),
              ),
            );
          },
          child: const BusCard("0", Duration.zero, Duration.zero, Duration.zero, home: true),
        );
      },
      error: (error, stackTrace) => const Text("Error"),
      loading: () => const Text("Loading"),
    );
  }
}
