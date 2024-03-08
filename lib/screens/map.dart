import 'package:flutter/material.dart';
import 'package:dotto/app.dart';
import 'package:dotto/components/color_fun.dart';
import 'package:dotto/components/map_detail.dart';
import 'package:dotto/components/widgets/map.dart';
import 'package:dotto/repository/find_rooms_in_use.dart';
import 'package:dotto/repository/read_json_file.dart';
import 'package:dotto/screens/map_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

final onMapSearchProvider = StateProvider((ref) => false);
final StateProvider<List<MapDetail>> mapSearchListProvider =
    StateProvider((ref) => []);
final mapPageProvider = StateProvider((ref) => 2);
final textEditingControllerProvider =
    StateProvider((ref) => TextEditingController());
final mapSearchBarFocusProvider = StateProvider((ref) => FocusNode());
final mapFocusMapDetailProvider = StateProvider(
    (ref) => const MapDetail('1', '0', null, '0', null, null, null));
final mapViewTransformationControllerProvider =
    StateProvider((ref) => TransformationController(Matrix4.identity()));
final searchDatetimeProvider = StateProvider((ref) => DateTime.now());

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  static const List<String> floorBarString = [
    '1',
    '2',
    '3',
    '4',
    '5',
    'R6',
    'R7'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 5),
          child: _mapSearchBar(),
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: _mapView()),
                // 階選択ボタン
                _mapFloorButton(context),
                _mapBottomInfo(),
                _mapBackonSearch(),
                _mapSearchListView(),
              ],
            )));
  }

  Widget _mapView() {
    return Consumer(
      builder: (context, ref, child) {
        final mapViewTransformationController =
            ref.watch(mapViewTransformationControllerProvider);
        return InteractiveViewer(
          maxScale: 10.0,
          // 倍率行列Matrix4
          transformationController: mapViewTransformationController,
          child: const Padding(
            padding: EdgeInsets.only(top: 80, right: 20, left: 20),
            // マップ表示
            child: MapGridScreen(),
          ),
        );
      },
    );
  }

  Widget _mapBackonSearch() {
    return Consumer(
      builder: (context, ref, child) {
        final mapSearchList = ref.watch(mapSearchListProvider);
        final mapSearchListNotifier = ref.watch(mapSearchListProvider.notifier);
        if (mapSearchList.isNotEmpty) {
          return Container(
            color: Colors.grey.withOpacity(0.5),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
              onTap: () {
                mapSearchListNotifier.state = [];
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _mapSearchBar() {
    return Consumer(builder: (context, ref, child) {
      final onMapSearch = ref.watch(onMapSearchProvider);
      final onMapSearchNotifier = ref.watch(onMapSearchProvider.notifier);
      final mapSearchList = ref.watch(mapSearchListProvider);
      final mapSearchListNotifier = ref.watch(mapSearchListProvider.notifier);
      final textEditingControllerNotifier =
          ref.watch(textEditingControllerProvider.notifier);
      return Container(
          color: (mapSearchList.isNotEmpty)
              ? Colors.grey.withOpacity(0.5)
              : Colors.transparent,
          child: Container(
            margin: const EdgeInsets.only(top: 15, right: 5, left: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AppBar(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(),
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                title: _mapSearchTextField(ref),
                automaticallyImplyLeading: false,
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.grey.shade100,
                foregroundColor: Colors.black87,
                actions: onMapSearch
                    ? [
                        IconButton(
                            onPressed: () {
                              mapSearchListNotifier.state = [];
                              onMapSearchNotifier.state = false;
                              textEditingControllerNotifier.state.clear();
                            },
                            icon: const Icon(Icons.clear)),
                      ]
                    : [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                        )
                      ]),
          ));
    });
  }

  void _onChangedSearchTextField(WidgetRef ref, String text) {
    final mapSearchListNotifier = ref.watch(mapSearchListProvider.notifier);
    final onMapSearchNotifier = ref.watch(onMapSearchProvider.notifier);
    if (text.isEmpty) {
      onMapSearchNotifier.state = false;
      mapSearchListNotifier.state = [];
    } else {
      onMapSearchNotifier.state = true;
      mapSearchListNotifier.state = MapDetailMap.instance.searchAll(text);
    }
  }

  Widget _mapSearchTextField(WidgetRef ref) {
    final textEditingControllerNotifier =
        ref.watch(textEditingControllerProvider.notifier);
    final mapSearchBarFocusNotifier =
        ref.watch(mapSearchBarFocusProvider.notifier);
    return TextField(
      focusNode: mapSearchBarFocusNotifier.state,
      controller: textEditingControllerNotifier.state,
      decoration: const InputDecoration(
        hintText: '検索(部屋名、教員名、メールアドレスなど)',
      ),
      autofocus: false,
      onChanged: (text) {
        _onChangedSearchTextField(ref, text);
      },
      onSubmitted: (text) {
        _onChangedSearchTextField(ref, text);
      },
    );
  }

  Widget _mapSearchListView() {
    return Consumer(
      builder: (context, ref, child) {
        final mapSearchListNotifier = ref.watch(mapSearchListProvider.notifier);
        final mapSearchList = ref.watch(mapSearchListProvider);
        final mapPageNotifier = ref.watch(mapPageProvider.notifier);
        final mapFocusMapDetailNotifier =
            ref.watch(mapFocusMapDetailProvider.notifier);
        final mapViewTransformationControllerProviderNotifier =
            ref.watch(mapViewTransformationControllerProvider.notifier);
        if (mapSearchList.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                    offset: Offset(2, 2),
                  )
                ],
              ),
              width: double.infinity,
              height: (mapSearchList.length * 60 < 200)
                  ? mapSearchList.length * 60
                  : 200,
              child: ListView.separated(
                itemCount: mapSearchList.length,
                itemBuilder: (context, int index) {
                  final MapDetail item = mapSearchListNotifier.state[index];
                  return ListTile(
                    onTap: () {
                      mapSearchListNotifier.state = [];
                      FocusScope.of(context).unfocus();
                      mapViewTransformationControllerProviderNotifier
                          .state.value
                          .setIdentity();
                      mapFocusMapDetailNotifier.state = item;
                      mapPageNotifier.state =
                          floorBarString.indexOf(item.floor);
                    },
                    title: Text(item.header),
                    leading: Text('${item.floor}階'),
                    trailing: const Icon(Icons.chevron_right),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _mapFloorButton(BuildContext context) {
    TextStyle floorBarTextStyle =
        const TextStyle(fontSize: 18.0, color: Colors.black87);
    TextStyle floorBarSelectedTextStyle =
        const TextStyle(fontSize: 18.0, color: customFunColor);
    // 350以下なら計算
    double floorButtonWidth = (MediaQuery.of(context).size.width - 30 < 350)
        ? MediaQuery.of(context).size.width - 30
        : 350;
    double floorButtonHeight = 50;
    return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.grey.withOpacity(0.9),
            width: floorButtonWidth,
            height: floorButtonHeight,
            // Providerから階数の変更を検知
            child: Consumer(builder: (context, ref, child) {
              final mapPage = ref.watch(mapPageProvider);
              final mapPageNotifier = ref.watch(mapPageProvider.notifier);
              final mapViewTransformationControllerProviderNotifier =
                  ref.watch(mapViewTransformationControllerProvider.notifier);
              final mapFocusMapDetailNotifier =
                  ref.watch(mapFocusMapDetailProvider.notifier);
              return Row(
                children: [
                  for (int i = 0; i < 7; i++) ...{
                    SizedBox(
                      width: floorButtonWidth / 7,
                      height: floorButtonHeight,
                      child: Center(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              fixedSize:
                                  Size(floorButtonWidth / 7, floorButtonHeight),
                              backgroundColor:
                                  (mapPage == i) ? Colors.black12 : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            // 階数の変更をProviderに渡す
                            onPressed: () {
                              mapViewTransformationControllerProviderNotifier
                                      .state =
                                  TransformationController(Matrix4(1, 0, 0, 0,
                                      0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1));
                              mapPageNotifier.state = i;
                              mapFocusMapDetailNotifier.state = const MapDetail(
                                  '1', '0', null, '0', null, null, null);
                              FocusScope.of(context).unfocus();
                            },
                            child: Center(
                                child: Text(
                              floorBarString[i],
                              style: (mapPage == i)
                                  ? floorBarSelectedTextStyle
                                  : floorBarTextStyle,
                            ))),
                      ),
                    ),
                  }
                ],
              );
            }),
          ),
        ));
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

  Widget _mapBottomInfo() {
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
                _mapInfoTile(TileColors.using, "下記設定時間に授業等で使用中の部屋"),
                _mapInfoTile(TileColors.toilet, 'トイレ及び給湯室'),
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
                      ...timeMap.entries
                          .map((item) => Expanded(
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
                              ))
                          .toList(),
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
}
