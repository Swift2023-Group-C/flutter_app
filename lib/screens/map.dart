import 'package:flutter/material.dart';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_app/components/map_detail.dart';
import 'package:flutter_app/screens/map_grid.dart';
import 'package:flutter_app/components/map_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onMapSearchProvider = StateProvider((ref) => false);
final StateProvider<List<MapDetail>> mapSearchListProvider =
    StateProvider((ref) => []);
final mapPageProvider = StateProvider((ref) => 2);
final textEditingControllerProvider =
    StateProvider((ref) => TextEditingController());
final mapSearchBarFocusProvider = StateProvider((ref) => FocusNode());

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
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
                        child: InteractiveViewer(
                            maxScale: 10.0,
                            // 倍率行列Matrix4
                            transformationController:
                                MapController.instance.getController(),
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(top: 80, right: 20, left: 20),
                              // マップ表示
                              child: MapGridScreen(),
                            ))),
                    // 階選択ボタン
                    _mapFloorButton(context),
                    _mapSearchListView(),
                  ],
                ))));
  }

  Widget _mapSearchBar() {
    return Consumer(builder: (context, ref, child) {
      final onMapSearch = ref.watch(onMapSearchProvider);
      final onMapSearchNotifier = ref.watch(onMapSearchProvider.notifier);
      final mapSearchListNotifier = ref.watch(mapSearchListProvider.notifier);
      final textEditingControllerNotifier =
          ref.watch(textEditingControllerProvider.notifier);
      return AppBar(
          title: _mapSearchTextField(ref),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white70,
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
                ]);
    });
  }

  Widget _mapSearchTextField(WidgetRef ref) {
    final mapSearchListNotifier = ref.watch(mapSearchListProvider.notifier);
    final onMapSearchNotifier = ref.watch(onMapSearchProvider.notifier);
    final textEditingControllerNotifier =
        ref.watch(textEditingControllerProvider.notifier);
    final mapSearchBarFocusNotifier =
        ref.watch(mapSearchBarFocusProvider.notifier);
    return TextField(
      focusNode: mapSearchBarFocusNotifier.state,
      controller: textEditingControllerNotifier.state,
      decoration: const InputDecoration(
        hintText: '検索',
      ),
      autofocus: false,
      onChanged: (String text) {
        if (text.isEmpty) {
          onMapSearchNotifier.state = false;
          mapSearchListNotifier.state = [];
        } else {
          onMapSearchNotifier.state = true;
          mapSearchListNotifier.state = MapDetailMap.instance.searchAll(text);
        }
      },
    );
  }

  Widget _mapSearchListView() {
    List<String> floorBarString = ['1', '2', '3', '4', '5', 'R1', 'R2'];
    return Consumer(
      builder: (context, ref, child) {
        final mapSearchListNotifier = ref.watch(mapSearchListProvider.notifier);
        final mapSearchList = ref.watch(mapSearchListProvider);
        final mapPageNotifier = ref.watch(mapPageProvider.notifier);
        if (mapSearchList.isNotEmpty) {
          return Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Container(
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  height: (mapSearchList.length * 60 < 200)
                      ? mapSearchList.length * 60
                      : 200,
                  child: ListView.separated(
                    itemCount: mapSearchList.length,
                    itemBuilder: (context, int index) {
                      final MapDetail item = mapSearchListNotifier.state[index];
                      return SizedBox(
                          height: 60,
                          child: ListTile(
                            onTap: () {
                              mapPageNotifier.state =
                                  floorBarString.indexOf(item.floor);
                              mapSearchListNotifier.state = [];
                              FocusScope.of(context).unfocus();
                            },
                            title: Text(item.header),
                          ));
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: 0,
                    ),
                  ),
                ),
              ));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _mapFloorButton(BuildContext context) {
    // インデックスに対応した階数
    List<String> floorBarString = ['1', '2', '3', '4', '5', 'R1', 'R2'];
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
                              mapPageNotifier.state = i;
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
}
