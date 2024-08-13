import 'package:dotto/app/controller/tab_controller.dart';
import 'package:dotto/app/domain/tab_item.dart';
import 'package:dotto/feature/map/domain/map_room_available_type.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/repository/app_status.dart';
import 'package:intl/intl.dart';

class MapDetailBottomSheet extends ConsumerWidget {
  const MapDetailBottomSheet({super.key, required this.floor, required this.roomName});
  final String floor;
  final String roomName;

  static const Color blue = Color(0xFF4A90E2);

  Widget scheduleTile(BuildContext context, DateTime begin, DateTime end, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            width: 5,
            color: blue,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateFormat('MM/dd').format(begin)),
          Row(
            children: [
              Text(
                "${DateFormat('HH:mm').format(begin)} ~ ${DateFormat('HH:mm').format(end)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: SelectableText(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          )
          // time
        ],
      ),
    );
  }

  Widget roomAvailable(RoomAvailableType type, bool status) {
    const fontColor = Colors.white;
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: blue.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            type.icon,
            color: fontColor,
            size: 20,
          ),
          Text(
            type.title,
            style: const TextStyle(
              color: fontColor,
            ),
          ),
          Icon(
            status ? Icons.circle_outlined : Icons.close_outlined,
            color: fontColor,
            size: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapDetailMap = ref.watch(mapDetailMapProvider);
    final searchDatetime = ref.watch(searchDatetimeProvider);
    return Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xFFF2F9FF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 2.0,
              blurRadius: 8.0,
            )
          ],
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AppStatus().isLoggedinGoogle
                    ? mapDetailMap.when(
                        data: (data) {
                          MapDetail? mapDetail = data.searchOnce(floor, roomName);
                          // 本体ここから
                          if (mapDetail != null) {
                            return <Widget>[
                              SelectableText(
                                mapDetail.header,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: double.infinity, height: 10),
                              Row(
                                children: [
                                  roomAvailable(RoomAvailableType.outlet, true),
                                  const SizedBox(width: 10),
                                  roomAvailable(RoomAvailableType.food, false),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (mapDetail.scheduleList != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...mapDetail.getScheduleListByDate(searchDatetime).map(
                                          (e) => scheduleTile(context, e.begin, e.end, e.title),
                                        ),
                                  ],
                                )
                              else if (mapDetail.detail != null)
                                SelectableText(mapDetail.detail!),
                              if (mapDetail.mail != null)
                                SelectableText('${mapDetail.mail}@fun.ac.jp'),
                            ];
                          } else {
                            return [
                              SelectableText(
                                roomName,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ];
                          }
                        },
                        error: (error, stackTrace) => [const Text('情報を取得できませんでした')],
                        loading: () => [
                          SelectableText(
                            roomName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: Center(
                              child: createProgressIndicator(),
                            ),
                          )
                        ],
                      )
                    : [
                        SelectableText(
                          roomName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        const Text("詳細は未来大Googleアカウントでログインすることで表示できます。"),
                        OutlinedButton(
                          onPressed: () {
                            final tabItemNotifier = ref.read(tabItemProvider.notifier);
                            tabItemNotifier.selected(TabItem.setting);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text("設定"),
                        ),
                      ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))),
            ),
          ],
        ));
  }
}
