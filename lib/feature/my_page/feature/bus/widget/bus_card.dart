import 'package:dotto/components/app_color.dart';
import 'package:dotto/feature/my_page/feature/bus/controller/bus_controller.dart';
import 'package:dotto/feature/my_page/feature/bus/domain/bus_type.dart';
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

  BusType getType() {
    if (["55", "55A", "55B", "55C", "55E", "55F"].contains(route)) {
      return BusType.goryokaku;
    }
    if (route == "55G") {
      return BusType.syowa;
    }
    if (route == "55H") {
      return BusType.kameda;
    }
    return BusType.other;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busIsTo = ref.watch(busIsToProvider);
    final myBusStop = ref.watch(myBusStopProvider);
    final tripType = getType();
    final headerText = tripType != BusType.other ? tripType.where + (busIsTo ? "から" : "行き") : "";
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.white,
      shadowColor: Colors.black,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: (home ? 0 : 10)),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (home)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      busIsTo ? "${myBusStop.name} → 未来大" : "未来大 → ${myBusStop.name}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, 5),
                    child: IconButton(
                      iconSize: 20,
                      color: AppColor.linkTextBlue,
                      onPressed: () {
                        ref.read(busIsToProvider.notifier).change();
                      },
                      icon: const Icon(
                        Icons.swap_horiz_outlined,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            if (route != "0")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$route $headerText"),
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
                  Divider(
                    height: 6,
                    color: tripType.dividerColor,
                  ),
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
                  ),
                ],
              )
            else
              const Text("今日の運行は終了しました。"),
            if (home)
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "バス一覧",
                    style: TextStyle(
                      color: AppColor.linkTextBlue,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColor.linkTextBlue,
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
