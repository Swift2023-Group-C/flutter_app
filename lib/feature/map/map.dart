import 'package:dotto/importer.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:dotto/feature/map/widget/map_bottom_info.dart';
import 'package:dotto/feature/map/widget/map_floor_button.dart';
import 'package:dotto/feature/map/widget/map_search.dart';
import 'package:dotto/feature/map/widget/map_grid.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 5),
          child: MapSearchBar(),
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
                const MapFloorButton(),
                const MapBottomInfo(),
                const MapBarrierOnSearch(),
                const MapSearchListView(),
              ],
            )));
  }

  Widget _mapView() {
    return Consumer(
      builder: (context, ref, child) {
        final mapViewTransformationController = ref.watch(mapViewTransformationControllerProvider);
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
}
