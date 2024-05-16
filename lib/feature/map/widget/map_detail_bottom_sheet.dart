import 'package:dotto/importer.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';

class MapDetailBottomSheet extends ConsumerWidget {
  const MapDetailBottomSheet(
      {super.key, required this.floor, required this.roomName});
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
                children: mapDetailMap.when(
                  data: (data) {
                    MapDetail? mapDetail = data.searchOnce(floor, roomName);
                    if (mapDetail != null) {
                      return <Widget>[
                        SelectableText(
                          mapDetail.header,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: double.infinity, height: 10),
                        if (mapDetail.detail != null)
                          SelectableText(mapDetail.detail!),
                        if (mapDetail.mail != null)
                          SelectableText('${mapDetail.mail}@fun.ac.jp'),
                      ];
                    } else {
                      return [
                        SelectableText(
                          roomName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ];
                    }
                  },
                  error: (error, stackTrace) => [const Text('情報を取得できませんでした')],
                  loading: () => [
                    SelectableText(
                      roomName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Center(
                        child: createProgressIndicator(),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close))),
            ),
          ],
        ));
  }
}
