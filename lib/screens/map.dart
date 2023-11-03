import 'package:flutter/material.dart';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_app/components/map_detail.dart';
import 'package:flutter_app/components/widgets/map.dart';
import 'package:flutter_app/screens/map_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                _mapInfo(),
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
        padding: const EdgeInsets.only(top: 20),
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

  Widget _mapInfo() {
    return Consumer(
      builder: (context, ref, child) {
        final mapViewTransformationController =
            ref.watch(mapViewTransformationControllerProvider);
        return Visibility(
            visible:
                mapViewTransformationController.value.getMaxScaleOnAxis() <=
                    1.5,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 80,
                  width: 200,
                  color: Colors.grey.shade400.withOpacity(0.8),
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _mapInfoTile(TileColors.using, "授業等で使用中の部屋"),
                      _mapInfoTile(TileColors.toilet, 'トイレ及び給湯室'),
                      _mapInfoTile(Colors.red, '検索結果'),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  Widget _mapInfoTile(Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(color: color, border: Border.all()),
          width: 12,
          height: 12,
        ),
        const SizedBox(width: 5),
        Text(text)
      ],
    );
  }
}
