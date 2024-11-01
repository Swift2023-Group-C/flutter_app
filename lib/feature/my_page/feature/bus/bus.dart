import 'package:collection/collection.dart';
import 'package:dotto/components/app_color.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/my_page/feature/bus/widget/bus_timetable.dart';
import 'package:dotto/feature/my_page/feature/bus/controller/bus_controller.dart';
import 'package:dotto/feature/my_page/feature/bus/domain/bus_trip.dart';
import 'package:dotto/feature/my_page/feature/bus/widget/bus_card.dart';
import 'package:dotto/feature/my_page/feature/bus/widget/bus_stop_select.dart';
import 'package:dotto/importer.dart';

final busKey = GlobalKey();

class BusScreen extends ConsumerWidget {
  const BusScreen({super.key});

  Widget busStopButton(
      BuildContext context, void Function()? onPressed, IconData icon, String title) {
    final double width = MediaQuery.sizeOf(context).width * 0.3;
    const double height = 80;
    return Container(
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.white,
          disabledForegroundColor: Colors.black87,
          surfaceTintColor: Colors.white,
          fixedSize: Size(width, height),
          padding: const EdgeInsets.all(3),
          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: title == "未来大" ? 0 : null,
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
    final busRefresh = ref.watch(busRefreshProvider);
    final busIsWeekday = ref.watch(busIsWeekdayNotifier);
    final busScrolled = ref.watch(busScrolledProvider);

    Widget myBusStopButton = busStopButton(context, () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const BusStopSelectScreen(),
      ));
    }, Icons.directions_bus, myBusStop.name);
    Widget funBusStopButton = busStopButton(context, null, Icons.school, '未来大');
    Widget departure = busIsTo ? myBusStopButton : funBusStopButton;
    Widget destination = busIsTo ? funBusStopButton : myBusStopButton;
    String fromToString = busIsTo ? "to_fun" : "from_fun";

    final btnChange = IconButton(
      iconSize: 20,
      color: AppColor.linkTextBlue,
      onPressed: () {
        ref.read(busIsToProvider.notifier).change();
        ref.read(busScrolledProvider.notifier).state = false;
      },
      icon: const Icon(
        Icons.swap_horiz_outlined,
      ),
    );

    bool arriveAtSoon = true;
    final busListWidget = busData != null
        ? busData[fromToString]![busIsWeekday ? "weekday" : "holiday"]!.map((busTrip) {
            final funBusTripStop =
                busTrip.stops.firstWhereOrNull((element) => element.stop.id == 14023);
            if (funBusTripStop == null) {
              return Container();
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
            bool hasKey = false;
            if (arriveAtSoon && arriveAt > Duration.zero) {
              arriveAtSoon = false;
              hasKey = true;
            }
            //return const SizedBox.shrink();
            //}
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
                busTrip.route,
                fromBusTripStop.time,
                toBusTripStop.time,
                arriveAt,
                isKameda: kameda,
                key: hasKey ? busKey : null,
              ),
            );
          }).toList()
        : [Container()];
    final scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (busScrolled) return;
      final currentContext = busKey.currentContext;
      if (currentContext == null) return;
      final box = currentContext.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      scrollController.animateTo(
        scrollController.offset + position.dy - 300,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      ref.read(busScrolledProvider.notifier).state = true;
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("バス一覧 ${busIsWeekday ? "平日" : "土日"}"),
        actions: [
          TextButton.icon(
            onPressed: () {
              ref.read(busIsWeekdayNotifier.notifier).change();
              ref.read(busScrolledProvider.notifier).state = false;
            },
            icon: const Icon(
              Icons.swap_horiz_outlined,
              color: Colors.white,
            ),
            label: Text(
              "${busIsWeekday ? "土日" : "平日"}へ ",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset(
                  "assets/bus.png",
                  width: MediaQuery.of(context).size.width * 0.57,
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
            child: busData != null
                ? SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: busListWidget,
                    ),
                  )
                : createProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
