import 'package:dotto/app/controller/tab_controller.dart';
import 'package:dotto/app/domain/tab_item.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/repository/app_status.dart';

class MapDetailBottomSheet extends ConsumerWidget {
  const MapDetailBottomSheet({super.key, required this.floor, required this.roomName});
  final String floor;
  final String roomName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapDetailMap = ref.watch(mapDetailMapProvider);
    return Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1.0,
              blurRadius: 5.0,
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
                          if (mapDetail != null) {
                            return <Widget>[
                              SelectableText(
                                mapDetail.header,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: double.infinity, height: 10),
                              if (mapDetail.detail != null) SelectableText(mapDetail.detail!),
                              if (mapDetail.mail != null)
                                SelectableText('${mapDetail.mail}@fun.ac.jp'),
                            ];
                          } else {
                            return [
                              SelectableText(
                                roomName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
