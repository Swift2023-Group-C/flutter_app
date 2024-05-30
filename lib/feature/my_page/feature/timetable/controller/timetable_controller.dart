import 'package:sqflite/sqflite.dart';

import 'package:dotto/importer.dart';
import 'package:dotto/feature/my_page/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/repository/db_config.dart';

final StateProvider<List<int>> personalLessonIdListProvider = StateProvider((ref) => []);
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
