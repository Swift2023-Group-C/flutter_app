import 'package:dotto/importer.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/repository/get_firebase_realtime_db.dart';

final StateProvider<Map<String, bool>> mapUsingMapProvider =
    StateProvider((ref) => {});
final onMapSearchProvider = StateProvider((ref) => false);
final StateProvider<List<MapDetail>> mapSearchListProvider =
    StateProvider((ref) => []);
final mapPageProvider = StateProvider((ref) => 2);
final textEditingControllerProvider =
    StateProvider((ref) => TextEditingController());
final mapSearchBarFocusProvider = StateProvider((ref) => FocusNode());
final mapFocusMapDetailProvider = StateProvider((ref) => MapDetail.none);
final mapViewTransformationControllerProvider =
    StateProvider((ref) => TransformationController(Matrix4.identity()));
final searchDatetimeProvider = StateProvider((ref) => DateTime.now());
final mapDetailMapProvider = FutureProvider(
  (ref) async {
    final snapshot = await GetFirebaseRealtimeDB.getData('map');
    Map<String, Map<String, MapDetail>> returnList = {
      '1': {},
      '2': {},
      '3': {},
      '4': {},
      '5': {},
      'R6': {},
      'R7': {}
    };
    if (snapshot.exists) {
      (snapshot.value as Map).forEach((floor, value) {
        (value as Map).forEach((roomName, value2) {
          returnList[floor]!.addAll(
              {roomName: MapDetail.fromFirebase(floor, roomName, value2)});
        });
      });
    } else {
      debugPrint('No Map data available.');
      throw Exception();
    }
    return MapDetailMap(returnList);
  },
);
