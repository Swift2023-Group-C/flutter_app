import 'package:dotto/importer.dart';

import 'package:dotto/feature/map/controller/map_controller.dart';

class MapDetailBottomSheet extends ConsumerWidget {
  const MapDetailBottomSheet({super.key, required this.mapDetail});
  final MapDetail mapDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        height: 200,
        width: double.infinity,
        color: Colors.blueGrey.shade100,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                ],
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
