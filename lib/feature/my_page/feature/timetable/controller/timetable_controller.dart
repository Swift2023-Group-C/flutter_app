import 'package:sqflite/sqflite.dart';

import 'package:dotto/importer.dart';
import 'package:dotto/feature/my_page/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/repository/db_config.dart';

final StateProvider<List<int>> personalLessonIdListProvider =
    StateProvider((ref) => []);
final StateProvider<Map<DateTime, Map<int, List<TimeTableCourse>>>>
    twoWeekTimeTableDataProvider = StateProvider((ref) => {});
final StateProvider<DateTime> focusTimeTableDayProvider = StateProvider((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});
final FutureProvider<List<Map<String, dynamic>>> weekPeriodAllRecordsProvider =
    FutureProvider(
  (ref) async {
    Database database = await openDatabase(SyllabusDBConfig.dbPath);
    List<Map<String, dynamic>> records =
        await database.rawQuery('SELECT * FROM week_period order by lessonId');
    return records;
  },
);
