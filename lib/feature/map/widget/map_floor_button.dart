import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';

class MapFloorButton extends ConsumerWidget {
  const MapFloorButton({super.key});

  static const List<String> floorBarString = ['5F', '4F', '3F', '2F', '1F', 'R6', 'R7'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapPage = ref.watch(mapPageProvider); // 階層状態
    final mapPageNotifier = ref.watch(mapPageProvider.notifier);
    final mapViewTransformationControllerProviderNotifier =
        ref.watch(mapViewTransformationControllerProvider.notifier);
    final mapFocusMapDetailNotifier = ref.watch(mapFocusMapDetailProvider.notifier);

    double floorButtonWidth = 50; // 横幅
    double floorButtonHeight = 50; // 高さ

    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(floorBarString.length, (i) {
            return SizedBox(
              width: floorButtonWidth,
              height: floorButtonHeight,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      (mapPage == i) ? Colors.grey.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  mapViewTransformationControllerProviderNotifier.state =
                      TransformationController(Matrix4.identity());
                  mapPageNotifier.state = i;
                  mapFocusMapDetailNotifier.state = MapDetail.none;
                  FocusScope.of(context).unfocus();
                },
                child: Text(
                  floorBarString[i],
                  style:
                      TextStyle(fontSize: 18.0, color: (mapPage == i) ? Colors.blue : Colors.white),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
