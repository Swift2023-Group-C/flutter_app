import 'package:dotto/importer.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:dotto/feature/map/domain/map_tile_type.dart';
import 'package:dotto/feature/map/widget/map_tile.dart';
import 'package:dotto/repository/find_rooms_in_use.dart';
import 'package:dotto/repository/read_json_file.dart';

class MapBottomInfo extends ConsumerWidget {
  const MapBottomInfo({super.key});

  Widget _mapInfoTile(Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(color: color, border: Border.all()),
          width: 11,
          height: 11,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }

  Future<Map<String, bool>> setUsingColor(DateTime dateTime) async {
    final Map<String, bool> classroomNoFloorMap = {
      "1": false,
      "2": false,
      "3": false,
      "4": false,
      "5": false,
      "6": false,
      "7": false,
      "8": false,
      "9": false,
      "10": false,
      "11": false,
      "12": false,
      "13": false,
      "14": false,
      "15": false,
      "16": false,
      "17": false,
      "18": false,
      "19": false,
      "50": false,
      "51": false
    };

    String scheduleFilePath = 'map/oneweek_schedule.json';
    Map<String, DateTime>? resourceIds;
    try {
      String fileContent = await readJsonFile(scheduleFilePath);
      resourceIds = findRoomsInUse(fileContent, dateTime);
    } catch (e) {
      debugPrint(e.toString());
      return classroomNoFloorMap;
    }

    if (resourceIds.isNotEmpty) {
      resourceIds.forEach((String resourceId, DateTime useEndTime) {
        debugPrint(resourceId);
        if (classroomNoFloorMap.containsKey(resourceId)) {
          classroomNoFloorMap[resourceId] = true;
        }
      });
    }
    return classroomNoFloorMap;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double floorButtonHeight = 45;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime monday = today.subtract(Duration(days: today.weekday - 1));
    DateTime nextSunday = monday.add(const Duration(days: 14, minutes: -1));
    Map<String, DateTime> timeMap = {
      '1限': today.add(const Duration(hours: 9)),
      '2限': today.add(const Duration(hours: 10, minutes: 40)),
      '3限': today.add(const Duration(hours: 13, minutes: 10)),
      '4限': today.add(const Duration(hours: 14, minutes: 50)),
      '5限': today.add(const Duration(hours: 16, minutes: 30)),
      '現在': today,
    };
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 75,
            width: 245,
            color: Colors.grey.shade400.withOpacity(0.6),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _mapInfoTile(MapColors.using, "下記設定時間に授業等で使用中の部屋"),
                _mapInfoTile(MapTileType.wc.backgroundColor, 'トイレ及び給湯室'),
                _mapInfoTile(Colors.red, '検索結果'),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
              height: floorButtonHeight,
              color: Colors.grey.shade400.withOpacity(0.8),
              alignment: Alignment.centerLeft,
              child: Consumer(
                builder: (context, ref, child) {
                  final searchDatetime = ref.watch(searchDatetimeProvider);
                  final searchDatetimeNotifier =
                      ref.watch(searchDatetimeProvider.notifier);
                  final mapUsingMapNotifier =
                      ref.watch(mapUsingMapProvider.notifier);
                  return Row(
                    children: [
                      ...timeMap.entries.map((item) => Expanded(
                            flex: 1,
                            child: Center(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                onPressed: () async {
                                  DateTime setDate = item.value;
                                  if (setDate.hour == 0) {
                                    setDate = DateTime.now();
                                  }
                                  searchDatetimeNotifier.state = setDate;
                                  mapUsingMapNotifier.state =
                                      await setUsingColor(setDate);
                                },
                                child: Center(
                                  child: Text(item.key),
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            onPressed: () {
                              DatePicker.showDateTimePicker(
                                context,
                                minTime: monday,
                                maxTime: nextSunday,
                                showTitleActions: true,
                                onConfirm: (date) async {
                                  searchDatetimeNotifier.state = date;
                                  mapUsingMapNotifier.state =
                                      await setUsingColor(date);
                                },
                                currentTime: searchDatetime,
                                locale: LocaleType.jp,
                              );
                            },
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(DateFormat('MM月dd日')
                                    .format(searchDatetime)),
                                Text(
                                    DateFormat('HH:mm').format(searchDatetime)),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ],
      ),
    );
  }
}
