import 'dart:convert';

import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/feature/my_page/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/db_config.dart';
import 'package:dotto/repository/read_json_file.dart';
import 'package:sqflite/sqflite.dart';

class TimetableRepository {
  static final TimetableRepository _instance = TimetableRepository._internal();
  factory TimetableRepository() {
    return _instance;
  }
  TimetableRepository._internal();

// 月曜から次の週の日曜までの日付を返す
  List<DateTime> getDateRange() {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    // 月曜
    var startDate = today.subtract(Duration(days: today.weekday - 1));

    List<DateTime> dates = [];
    for (int i = 0; i < 14; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }

    return dates;
  }

  Future<Map<String, dynamic>?> fetchDB(int lessonId) async {
    Database database = await openDatabase(SyllabusDBConfig.dbPath);

    List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT LessonId, 過去問, 授業名 FROM sort where LessonId = ?', [lessonId]);
    if (records.isEmpty) {
      return null;
    }
    return records.first;
  }

  Future<List<int>> loadPersonalTimeTableList() async {
    final jsonString = await UserPreferences.getString(
        UserPreferenceKeys.personalTimetableListKey);
    if (jsonString != null) {
      return List<int>.from(json.decode(jsonString));
    }
    return [];
  }

  Future<Map<String, int>> loadPersonalTimeTableMapString() async {
    List<int> personalTimeTableListInt = await loadPersonalTimeTableList();

    Database database = await openDatabase(SyllabusDBConfig.dbPath);
    Map<String, int> loadPersonalTimeTableMap = {};
    List<Map<String, dynamic>> records = await database.rawQuery(
        'select LessonId, 授業名 from sort where LessonId in (${personalTimeTableListInt.join(",")})');
    for (var record in records) {
      String lessonName = record['授業名'];
      int lessonId = record['LessonId'];
      loadPersonalTimeTableMap[lessonName] = lessonId;
    }
    return loadPersonalTimeTableMap;
  }

// 施設予約のjsonファイルの中から取得している科目のみに絞り込み
  Future<List<dynamic>> filterTimeTable() async {
    print("filterTimeTable");
    String fileName = 'map/oneweek_schedule.json';
    String jsonString = await readJsonFile(fileName);
    print("filterTimeTable get");
    List<dynamic> jsonData = json.decode(jsonString);

    List<int> personalTimeTableList = await loadPersonalTimeTableList();

    List<dynamic> filteredData = [];
    for (int lessonId in personalTimeTableList) {
      for (var item in jsonData) {
        if (item['lessonId'] == lessonId.toString()) {
          filteredData.add(item);
        }
      }
    }
    return filteredData;
  }

  Future<Map<DateTime, Map<int, List<TimeTableCourse>>>> get2WeekLessonSchedule(
      WidgetRef ref) async {
    final List<DateTime> dates = getDateRange();
    Map<DateTime, Map<int, List<TimeTableCourse>>> twoWeekLessonSchedule = {};
    for (var date in dates) {
      twoWeekLessonSchedule[date] = await dailyLessonSchedule(date);
    }
    return twoWeekLessonSchedule;
  }

// 時間を入れたらその日の授業を返す
  Future<Map<int, List<TimeTableCourse>>> dailyLessonSchedule(
      DateTime selectTime) async {
    Map<int, Map<int, TimeTableCourse>> periodData = {
      1: {},
      2: {},
      3: {},
      4: {},
      5: {},
      6: {}
    };
    Map<int, List<TimeTableCourse>> returnData = {};

    List<dynamic> lessonData = await filterTimeTable();

    for (var item in lessonData) {
      DateTime lessonTime = DateTime.parse(item['start']);

      if (selectTime.day == lessonTime.day) {
        int period = item['period'];
        int lessonId = int.parse(item['lessonId']);
        List<int> resourceId = [];
        try {
          resourceId.add(int.parse(item['resourceId']));
        } catch (e) {
          // resourceIdが空白
        }
        if (periodData.containsKey(period)) {
          if (periodData[period]!.containsKey(lessonId)) {
            periodData[period]![lessonId]!.resourseIds.addAll(resourceId);
            continue;
          }
        }
        periodData[period]![lessonId] =
            TimeTableCourse(lessonId, item['title'], resourceId);
      }
    }

    String jsonData = await readJsonFile('home/cancel_lecture.json');
    List<dynamic> cancelLectureData = jsonDecode(jsonData);
    jsonData = await readJsonFile('home/sup_lecture.json');
    List<dynamic> supLectureData = jsonDecode(jsonData);
    Map<String, int> loadPersonalTimeTableMap =
        await loadPersonalTimeTableMapString();

    for (var cancelLecture in cancelLectureData) {
      DateTime dt = DateTime.parse(cancelLecture['date']);
      if (dt.month == selectTime.month && dt.day == selectTime.day) {
        String lessonName = cancelLecture['lessonName'];
        if (loadPersonalTimeTableMap.containsKey(lessonName)) {
          int lessonId = loadPersonalTimeTableMap[lessonName]!;
          periodData[cancelLecture['period']]![lessonId] =
              TimeTableCourse(lessonId, lessonName, [], cancel: true);
        }
      }
    }

    for (var supLecture in supLectureData) {
      DateTime dt = DateTime.parse(supLecture['date']);
      if (dt.month == selectTime.month && dt.day == selectTime.day) {
        String lessonName = supLecture['lessonName'];
        if (loadPersonalTimeTableMap.containsKey(lessonName)) {
          int lessonId = loadPersonalTimeTableMap[lessonName]!;
          periodData[supLecture['period']]![lessonId]!.sup = true;
        }
      }
    }
    periodData.forEach((key, value) {
      returnData[key] = value.values.toList();
    });
    return returnData;
  }
}
