import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';
import 'package:dotto/importer.dart';

final funchDateProvider = NotifierProvider<FunchDateNotifier, DateTime>(() {
  return FunchDateNotifier();
});

class FunchDateNotifier extends Notifier<DateTime> {
  // 初期値を設定する
  @override
  DateTime build() {
    return DateTime(2024, 11, 28);
  }

  void set(DateTime dt) {
    state = dt;
  }

  void today() {
    state = DateTime.now();
  }
}

final funchAllMenuProvider =
    NotifierProvider<FunchMenuNotifier, List<FunchMenu>?>(() => FunchMenuNotifier());
final funchDaysMenuProvider =
    NotifierProvider<FunchDateMenuNotifier, Map<DateTime, List<FunchMenu>>?>(
        () => FunchDateMenuNotifier());
final funchMonthMenuProvider =
    NotifierProvider<FunchDateMenuNotifier, Map<DateTime, List<FunchMenu>>?>(
        () => FunchDateMenuNotifier());

class FunchMenuNotifier extends Notifier<List<FunchMenu>?> {
  @override
  List<FunchMenu>? build() {
    return null;
  }

  void set(List<FunchMenu> list) {
    state = list;
  }

  List<FunchMenu> getMenuByCategory(int category) {
    if (state == null) return [];
    return state!.where((element) => element.category == category).toList();
  }

  FunchMenu? getMenuById(int id) {
    if (state == null) return null;
    return state!.firstWhere((element) => element.itemCode == id);
  }
}

class FunchDateMenuNotifier extends Notifier<Map<DateTime, List<FunchMenu>>?> {
  @override
  Map<DateTime, List<FunchMenu>>? build() {
    return null;
  }

  void set(Map<DateTime, List<FunchMenu>> map) {
    state = map;
  }
}
