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
    NotifierProvider<FunchCoopMenuNotifier, List<FunchCoopMenu>?>(() => FunchCoopMenuNotifier());
final funchDaysMenuProvider =
    NotifierProvider<FunchDateMenuNotifier, Map<DateTime, List<FunchCoopMenu>>?>(
        () => FunchDateMenuNotifier());
final funchMonthMenuProvider =
    NotifierProvider<FunchDateMenuNotifier, Map<DateTime, List<FunchCoopMenu>>?>(
        () => FunchDateMenuNotifier());

class FunchCoopMenuNotifier extends Notifier<List<FunchCoopMenu>?> {
  @override
  List<FunchCoopMenu>? build() {
    return null;
  }

  void set(List<FunchCoopMenu> list) {
    state = list;
  }

  List<FunchCoopMenu> getMenuByCategory(int category) {
    if (state == null) return [];
    return state!.where((element) => element.category == category).toList();
  }

  FunchCoopMenu? getMenuById(int id) {
    if (state == null) return null;
    return state!.firstWhere((element) => element.itemCode == id);
  }
}

class FunchDateMenuNotifier extends Notifier<Map<DateTime, List<FunchCoopMenu>>?> {
  @override
  Map<DateTime, List<FunchCoopMenu>>? build() {
    return null;
  }

  void set(Map<DateTime, List<FunchCoopMenu>> map) {
    state = map;
  }
}
