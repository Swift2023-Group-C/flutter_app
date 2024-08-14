import 'package:dotto/feature/my_page/feature/bus/repository/bus_repository.dart';
import 'package:dotto/importer.dart';

class BusCard extends ConsumerWidget {
  const BusCard(this.route, this.beginTime, this.endTime, this.arriveAt, {super.key});
  final String route;
  final Duration beginTime;
  final Duration endTime;
  final Duration arriveAt;

  String getHeader() {
    if (["55", "55A", "55B", "55C", "55E", "55F"].contains(route)) {
      return "五稜郭方面";
    }
    if (route == "55G") {
      return "昭和方面";
    }
    if (route == "55H") {
      return "亀田支所";
    }
    return "";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            Text(getHeader()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  BusRepository().formatDuration(beginTime),
                  style: const TextStyle(fontSize: 40),
                ),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: const Text('発'),
                ),
                const Spacer(),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: Text('${BusRepository().formatDuration(endTime)}着'),
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
