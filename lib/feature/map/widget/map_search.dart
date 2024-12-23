import 'package:dotto/feature/map/widget/map_detail_bottom_sheet.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';

class MapSearchBar extends ConsumerWidget {
  const MapSearchBar({super.key});

  void _onChangedSearchTextField(WidgetRef ref, String text) {
    final mapSearchListNotifier = ref.watch(mapSearchListProvider.notifier);
    final onMapSearchNotifier = ref.watch(onMapSearchProvider.notifier);
    final mapDetailMap = ref.watch(mapDetailMapProvider);
    if (text.isEmpty) {
      onMapSearchNotifier.state = false;
      mapSearchListNotifier.state = [];
    } else {
      onMapSearchNotifier.state = true;
      mapDetailMap.whenData((data) {
        mapSearchListNotifier.state = data.searchAll(text);
      });
    }
  }

  /// サーチバーのテキストフィールド
  Widget _mapSearchTextField(WidgetRef ref) {
    final textEditingControllerNotifier = ref.watch(textEditingControllerProvider.notifier);
    final mapSearchBarFocusNotifier = ref.watch(mapSearchBarFocusProvider.notifier);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onMapSearch = ref.watch(onMapSearchProvider);
    final onMapSearchNotifier = ref.watch(onMapSearchProvider.notifier);
    final mapSearchList = ref.watch(mapSearchListProvider);
    final mapSearchListNotifier = ref.watch(mapSearchListProvider.notifier);
    final textEditingControllerNotifier = ref.watch(textEditingControllerProvider.notifier);
    return Container(
        color: (mapSearchList.isNotEmpty) ? Colors.white.withOpacity(0.9) : Colors.transparent,
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
              //文字が入力されたときのボタンの動作
              actions: onMapSearch
                  ? [
                      IconButton(
                          //×が押されたときの動作
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
  }
}

/// 背景の色を設定
class MapBarrierOnSearch extends ConsumerWidget {
  const MapBarrierOnSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapSearchList = ref.watch(mapSearchListProvider);
    final mapSearchListNotifier = ref.watch(mapSearchListProvider.notifier);
    if (mapSearchList.isNotEmpty) {
      return Container(
        color: Colors.white.withOpacity(0.9),
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
  }
}

/// 検索予測結果
class MapSearchListView extends ConsumerWidget {
  const MapSearchListView({super.key});

  static const List<String> floorBarString = ['5', '4', '3', '2', '1', 'R6', 'R7'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapSearchListNotifier = ref.watch(mapSearchListProvider.notifier);
    final mapSearchList = ref.watch(mapSearchListProvider);
    final mapPageNotifier = ref.watch(mapPageProvider.notifier);
    final mapFocusMapDetailNotifier = ref.watch(mapFocusMapDetailProvider.notifier);
    final mapViewTransformationControllerProviderNotifier =
        ref.watch(mapViewTransformationControllerProvider.notifier);
    final mapSearchBarFocusNotifier = ref.watch(mapSearchBarFocusProvider.notifier);
    if (mapSearchList.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("検索結果"),
            Flexible(
              child: ListView.separated(
                itemCount: mapSearchList.length,
                itemBuilder: (context, int index) {
                  final MapDetail item = mapSearchListNotifier.state[index];
                  return ListTile(
                    onTap: () {
                      mapSearchListNotifier.state = [];
                      FocusScope.of(context).unfocus();
                      mapViewTransformationControllerProviderNotifier.state.value.setIdentity();
                      mapFocusMapDetailNotifier.state = item;
                      mapPageNotifier.state = floorBarString.indexOf(item.floor);
                      showBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return MapDetailBottomSheet(floor: item.floor, roomName: item.roomName);
                        },
                      );
                      mapSearchBarFocusNotifier.state.unfocus();
                    },
                    title: Text(item.header),
                    leading: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        const Icon(Icons.search),
                        Text('${item.floor}階'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
