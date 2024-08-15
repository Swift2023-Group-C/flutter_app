import 'package:dotto/feature/my_page/feature/bus/controller/bus_controller.dart';
import 'package:dotto/feature/my_page/feature/bus/repository/bus_repository.dart';
import 'package:dotto/importer.dart';

class BusCard extends ConsumerWidget {
  const BusCard(this.route, this.beginTime, this.endTime, this.arriveAt,
      {super.key, this.isKameda = false, this.home = false});
  final String route;
  final Duration beginTime;
  final Duration endTime;
  final Duration arriveAt;
  final bool isKameda;
  final bool home;

  String getHeader(bool busIsTo) {
    String s = "";
    if (["55", "55A", "55B", "55C", "55E", "55F"].contains(route)) {
      s = "五稜郭方面";
    }
    if (route == "55G") {
      s = "昭和方面";
    }
    if (route == "55H") {
      s = "亀田支所";
    }
    if (s.isNotEmpty) {
      s += busIsTo ? "から" : "行き";
    }
    return "$route $s";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busIsTo = ref.watch(busIsToProvider);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.white,
      shadowColor: Colors.black,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getHeader(busIsTo)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  BusRepository().formatDuration(beginTime),
                  style: const TextStyle(fontSize: 40),
                ),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: Text(isKameda && busIsTo ? '亀田支所発' : '発'),
                ),
                const Spacer(),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: Text(
                      '${BusRepository().formatDuration(endTime)}${isKameda && !busIsTo ? '亀田支所着' : '着'}'),
                )
              ],
            ),
            const Divider(height: 6),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '出発まで${arriveAt.inMinutes}分',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
