import 'dart:convert';
import 'package:flutter_app/repository/read_json_file.dart';
import 'package:flutter_app/components/setting_user_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<List<int>> personalLessonIdListProvider =
    StateProvider((ref) => []);

Future<List<int>> loadPersonalTimeTableList(WidgetRef ref) async {
  final jsonString = await UserPreferences.getFinishList();
  if (jsonString != null) {
    final personalLessonIdListNotifier =
        ref.read(personalLessonIdListProvider.notifier);
    personalLessonIdListNotifier.state =
        List<int>.from(json.decode(jsonString));
    return List<int>.from(json.decode(jsonString));
  }
  return [];
}

Future<void> savePersonalTimeTableList(
    List<int> personalTimeTableList, WidgetRef ref) async {
  await UserPreferences.setFinishList(json.encode(personalTimeTableList));
  final personalLessonIdListNotifier =
      ref.watch(personalLessonIdListProvider.notifier);
  personalLessonIdListNotifier.state = [...personalTimeTableList];
}

// 施設予約のjsonファイルの中から取得している科目のみに絞り込み
Future<List<dynamic>> filterTimeTable(WidgetRef ref) async {
  String fileName = 'map/oneweek_schedule.json';
  String jsonString = await readJsonFile(fileName);
  List<dynamic> jsonData = json.decode(jsonString);

  List<int> personalTimeTableList = await loadPersonalTimeTableList(ref);

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

// 月曜から次の週の日曜までの日付を返す
List<DateTime> getDateRange() {
  var now = DateTime.now();
  // 月曜
  var startDate = now.subtract(Duration(days: now.weekday - 1));

  List<DateTime> dates = [];
  for (int i = 0; i < 14; i++) {
    dates.add(startDate.add(Duration(days: i)));
  }

  return dates;
}

class TimeTableCourse {
  final int lessonId;
  final String title;
  final List<int> resourseIds;

  TimeTableCourse(this.lessonId, this.title, this.resourseIds);

  @override
  String toString() {
    return "$lessonId $title $resourseIds";
  }
}

// 時間を入れたらその日の授業を返す
Future<Map<int, TimeTableCourse>> dailyLessonSchedule(
    WidgetRef ref, DateTime selectTime) async {
  Map<int, TimeTableCourse> periodData = {};
  print(selectTime);

  List<dynamic> lessonData = await filterTimeTable(ref);

  for (var item in lessonData) {
    DateTime lessonTime = DateTime.parse(item['start']);

    if (selectTime.day == lessonTime.day) {
      int period = item['period'];
      if (periodData.containsKey(period)) {
        periodData[period]!.resourseIds.add(int.parse(item['resourceId']));
      } else {
        List<int> resourceId = [];
        if (item['resourceId'] != null) {
          try {
            resourceId.add(int.parse(item['resourceId']));
          } catch (e) {
            // 空白
          }
        }
        periodData[period] = TimeTableCourse(
            int.parse(item['lessonId']), item['title'], resourceId);
      }
    }
  }
  return periodData;
}
