import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/my_page/feature/funch/repository/funch_repository.dart';
import 'package:dotto/importer.dart';

final funchDateProvider = NotifierProvider<FunchDateNotifier, DateTime>(() {
  return FunchDateNotifier();
});

class FunchDateNotifier extends Notifier<DateTime> {
  // 初期値を設定する
  @override
  DateTime build() {
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  void set(DateTime dt) {
    state = dt;
  }

  void today() {
    state = DateTime.now();
  }
}

final funchAllCoopMenuProvider =
    NotifierProvider<FunchCoopMenuNotifier, List<FunchCoopMenu>?>(() => FunchCoopMenuNotifier());
final funchDaysMenuProvider = Provider(
  (ref) async {
    final funchAllCoopMenu = ref.watch(funchAllCoopMenuProvider);
    return await FunchRepository().getDaysMenu(ref, funchAllCoopMenu);
  },
);
final funchMonthMenuProvider = Provider(
  (ref) {
    final funchAllCoopMenu = ref.watch(funchAllCoopMenuProvider);
    // TODO: ここで月のメニューを取得する
  },
);

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

final funchAllOriginalMenuProvider =
    NotifierProvider<FunchOriginalMenuNotifier, List<FunchOriginalMenu>?>(
        () => FunchOriginalMenuNotifier());

class FunchOriginalMenuNotifier extends Notifier<List<FunchOriginalMenu>?> {
  @override
  List<FunchOriginalMenu>? build() {
    return null;
  }

  void set(List<FunchOriginalMenu> list) {
    state = list;
  }
}
