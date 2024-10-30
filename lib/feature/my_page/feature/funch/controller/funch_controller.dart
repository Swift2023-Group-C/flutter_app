import 'package:dotto/feature/my_page/feature/funch/funch.dart';
import 'package:dotto/importer.dart';

final funchDateProvider = NotifierProvider<FunchDateNotifier, DateTime>(() {
  return FunchDateNotifier();
});

class FunchDateNotifier extends Notifier<DateTime> {
  // 初期値を設定する
  @override
  DateTime build() {
    return DateTime.now();
  }

  void set(DateTime dt) {
    state = dt;
  }

  void today() {
    state = DateTime.now();
  }
}

//以下自作
final funchMonthDateProvider = NotifierProvider<FunchMonthDateProvider, List<DateTime>>(() {
  return FunchMonthDateProvider();
});

class FunchMonthDateProvider extends Notifier<List<DateTime>> {
  // 初期値を設定する
  @override
  List<DateTime> build() {
    return getDateMonth(DateTime.now().month);
  }

  void set(List<DateTime> dt) {
    state = dt;
  }

  //指定した月の曜日を返す
  List<DateTime> getDateMonth(int specifiedMonth) {
    final now = DateTime.now();
    DateTime startDate = DateTime(now.year, specifiedMonth, 1);

    if (specifiedMonth < now.month) {
      startDate = DateTime(now.year + 1, specifiedMonth, 1); //過去の月は来年にする
    }
    List<DateTime> dates = [];
    final nextMonthFirst = DateTime(startDate.year, specifiedMonth + 1, 1);
    final monthDays = nextMonthFirst.subtract(const Duration(days: 1)).day;

    for (int i = 0; i < monthDays; i++) {
      final date = startDate.add(Duration(days: i));
      if (date.weekday < 6) dates.add(date); //土日は除外
    }
    return dates;
  }

  void setDateMonth(int month) {
    state = getDateMonth(month);
  }
}
