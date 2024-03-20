import 'package:flutter/material.dart';
import 'package:dotto/screens/map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dotto/components/widgets/map.dart';

class MapGridScreen extends StatelessWidget {
  const MapGridScreen({super.key});

  static const List<String> gridMapsList = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "R6",
    "R7"
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final mapPage = ref.watch(mapPageProvider);
        return StaggeredGrid.count(
          crossAxisCount: 48,
          children: [
            ...GridMaps.mapTileListMap[gridMapsList[mapPage]]!.map(
              (e) {
                return StaggeredGridTile.count(
                    crossAxisCellCount: e.width,
                    mainAxisCellCount: e.height,
                    child: e);
              },
            )
          ],
        );
      },
    );
  }
}
