import 'package:dotto/feature/my_page/feature/bus/bus_timetable.dart';
import 'package:dotto/feature/my_page/feature/bus/controller/bus_controller.dart';
import 'package:dotto/feature/my_page/feature/bus/widget/bus_card.dart';
import 'package:dotto/importer.dart';

//make by zaki
class BusScreen extends ConsumerWidget {
  const BusScreen({super.key});

  Widget infoButton(BuildContext context, void Function() onPressed, IconData icon, String title) {
    //final double width = MediaQuery.sizeOf(context).width * 0.26;
    const double width = 80;
    const double height = 80;
    return Container(
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            surfaceTintColor: Colors.white,
            fixedSize: Size(width, height),
            padding: EdgeInsets.all(0),
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15))),
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                  child: Container(
                width: 35,
                height: 35,
                //color: customFunColor,
                child: Center(
                    child: Icon(
                  icon,
                  color: Colors.grey,
                  size: 28,
                )),
              )),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(fontSize: 11),
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
    Widget departure = infoButton(context, () {}, Icons.directions_bus, '亀田');
    Widget destination = infoButton(context, () {}, Icons.school, '未来大');

    final btnChange = IconButton(
        iconSize: 20,
        color: Colors.blue,
        onPressed: () {},
        icon: const Icon(
          Icons.autorenew,
        ));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("時刻表一覧"),
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
                final data = allData["to_fun"]!["holiday"]!;

                return ListView.builder(
                  itemCount: data.length, // 実際のデータ数に応じて調整
                  itemBuilder: (context, index) {
                    final funBusTripStop =
                        data[index].stops.firstWhere((element) => element.stop.id == 14023);
                    final targetBusTripStop =
                        data[index].stops.firstWhere((element) => element.stop.id == 14013);
                    final now = DateTime.now();
                    final nowDuration = Duration(hours: now.hour, minutes: now.minute);
                    final arriveAt = targetBusTripStop.time - nowDuration;
                    if (arriveAt.isNegative) {
                      return const SizedBox.shrink();
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusTimetableScreen(data[index]),
                          ),
                        );
                      },
                      child: BusCard(
                          data[index].route, targetBusTripStop.time, funBusTripStop.time, arriveAt),
                    );
                  },
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
