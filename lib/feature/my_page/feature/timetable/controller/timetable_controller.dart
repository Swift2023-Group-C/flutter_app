import 'package:dotto/feature/my_page/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/feature/my_page/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/importer.dart';

final StateProvider<List<int>> personalLessonIdListProvider =
    StateProvider((ref) => []);
final FutureProvider<Map<DateTime, Map<int, List<TimeTableCourse>>>>
    twoWeekTimeTableDataProvider = FutureProvider((ref) async {
  final List<DateTime> dates = TimetableRepository().getDateRange();
  Map<DateTime, Map<int, List<TimeTableCourse>>> twoWeekLessonSchedule = {};
  for (var date in dates) {
    twoWeekLessonSchedule[date] =
        await TimetableRepository().dailyLessonSchedule(date);
  }
  return twoWeekLessonSchedule;
});
final StateProvider<DateTime> focusTimeTableDayProvider = StateProvider((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});
