import 'dart:convert';

import 'package:dotto/components/setting_user_info.dart';
import 'package:sqflite/sqflite.dart';

import 'package:dotto/importer.dart';
import 'package:dotto/feature/my_page/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/repository/db_config.dart';

final personalLessonIdListProvider =
    NotifierProvider<PersonalLessonIdListNotifier, List<int>>(() => PersonalLessonIdListNotifier());

class PersonalLessonIdListNotifier extends Notifier<List<int>> {
  @override
  List<int> build() {
    return [];
  }

  void add(int lessonId) {
    state = [...state, lessonId];
  }

  void remove(int lessonId) {
    state = state.where((element) => element != lessonId).toList();
  }

  void set(List<int> lessonIdList) {
    state = [...lessonIdList];
  }
}

final saveTimetableProvider = Provider((ref) async {
  final personalLessonIdList = ref.watch(personalLessonIdListProvider);
  await UserPreferences.setString(
      UserPreferenceKeys.personalTimetableListKey, json.encode(personalLessonIdList));
  await UserPreferences.setInt(
      UserPreferenceKeys.personalTimetableLastUpdateKey, DateTime.now().millisecondsSinceEpoch);
});

final StateProvider<Map<DateTime, Map<int, List<TimeTableCourse>>>?> twoWeekTimeTableDataProvider =
    StateProvider((ref) => null);
final StateProvider<DateTime> focusTimeTableDayProvider = StateProvider((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});
final FutureProvider<List<Map<String, dynamic>>> weekPeriodAllRecordsProvider = FutureProvider(
  (ref) async {
    Database database = await openDatabase(SyllabusDBConfig.dbPath);
    List<Map<String, dynamic>> records =
        await database.rawQuery('SELECT * FROM week_period order by lessonId');
    return records;
  },
);
final StateProvider<int> currentTimetablePageIndexProvider = StateProvider((ref) {
  DateTime now = DateTime.now();
  if ((now.month >= 9) || (now.month <= 2)) {
    return 1;
  }
  return 0;
});
final StateProvider<PageController> timetablePageControllerProvider = StateProvider((ref) {
  DateTime now = DateTime.now();
  if ((now.month >= 9) || (now.month <= 2)) {
    return PageController(initialPage: 1);
  }
  return PageController(initialPage: 0);
});
final StateProvider<bool> courseCancellationFilterEnabledProvider = StateProvider((ref) => true);
final StateProvider<String> courseCancellationSelectedTypeProvider = StateProvider((ref) => "すべて");
