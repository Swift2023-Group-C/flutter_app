import 'package:collection/collection.dart';
import 'package:dotto/feature/my_page/feature/bus/widget/bus_timetable.dart';
import 'package:dotto/feature/my_page/feature/bus/controller/bus_controller.dart';
import 'package:dotto/feature/my_page/feature/bus/domain/bus_trip.dart';
import 'package:dotto/feature/my_page/feature/bus/widget/bus_card.dart';
import 'package:dotto/feature/my_page/feature/bus/widget/bus_stop_select.dart';
import 'package:dotto/importer.dart';

//make by zaki
class BusScreen extends ConsumerWidget {
  const BusScreen({super.key});

  Widget busStopButton(
      BuildContext context, void Function() onPressed, IconData icon, String title) {
    final double width = MediaQuery.sizeOf(context).width * 0.3;
    const double height = 80;
    return Container(
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.white,
          fixedSize: Size(width, height),
          padding: const EdgeInsets.all(3),
          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.grey,
                size: 28,
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busData = ref.watch(busDataProvider);
    final myBusStop = ref.watch(myBusStopProvider);
    final busIsTo = ref.watch(busIsToProvider);

    Widget myBusStopButton = busStopButton(context, () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const BusStopSelectScreen(),
      ));
    }, Icons.directions_bus, myBusStop.name);
    Widget funBusStopButton = busStopButton(context, () {}, Icons.school, '未来大');
    Widget departure = busIsTo ? myBusStopButton : funBusStopButton;
    Widget destination = busIsTo ? funBusStopButton : myBusStopButton;
    String fromToString = busIsTo ? "to_fun" : "from_fun";

    final btnChange = IconButton(
      iconSize: 20,
      color: Colors.blue,
      onPressed: () {
        ref.read(busIsToProvider.notifier).change();
      },
      icon: const Icon(
        Icons.autorenew,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("バス一覧"),
      ),
      body: Column(
        children: [
          // Icon(Icons.line_start,
          //   size: 50, color: Colors.blue), // ここにアイコンを追加
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset(
                  "assets/bus.png",
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    departure,
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        btnChange,
                      ],
                    ),
                    destination,
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: busData.when(
              data: (allData) {
                final data = allData[fromToString]!["weekday"]!;

                return ListView(
                  children: data.map((busTrip) {
                    final funBusTripStop =
                        busTrip.stops.firstWhereOrNull((element) => element.stop.id == 14023);
                    if (funBusTripStop == null) {
                      return Container();
                    }
                    BusTripStop? targetBusTripStop = busTrip.stops
                        .firstWhereOrNull((element) => element.stop.id == myBusStop.id);
                    bool kameda = false;
                    if (targetBusTripStop == null) {
                      targetBusTripStop =
                          busTrip.stops.firstWhere((element) => element.stop.id == 14013);
                      kameda = true;
                    }
                    final fromBusTripStop = busIsTo ? targetBusTripStop : funBusTripStop;
                    final toBusTripStop = busIsTo ? funBusTripStop : targetBusTripStop;
                    final now = DateTime.now();
                    final nowDuration = Duration(hours: now.hour, minutes: now.minute);
                    final arriveAt = fromBusTripStop.time - nowDuration;
                    if (arriveAt.isNegative) {
                      return const SizedBox.shrink();
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusTimetableScreen(busTrip),
                          ),
                        );
                      },
                      child: BusCard(
                          busTrip.route, fromBusTripStop.time, toBusTripStop.time, arriveAt,
                          isKameda: kameda),
                    );
                  }).toList(),
                );
              },
              error: (error, stackTrace) => const Text("Error"),
              loading: () => const Text("Loading"),
            ),
          ),
        ],
      ),
    );
  }
}