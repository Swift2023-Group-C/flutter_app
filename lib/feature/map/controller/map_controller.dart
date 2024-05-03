import 'package:dotto/importer.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';

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
final mapDetailMapProvider = StateProvider((ref) => MapDetailMap());
