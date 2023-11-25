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
        ref.watch(personalLessonIdListProvider.notifier);
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
  print(filteredData);
  return filteredData;
}

// 2日前から7日後までの日付を返す
List<DateTime> getDateRange() {
  var now = DateTime.now();
  var startDate = now.subtract(const Duration(days: 2));

  List<DateTime> dates = [];
  for (int i = 0; i <= 7; i++) {
    dates.add(startDate.add(Duration(days: i)));
  }

  return dates;
}

// 時間を入れたらその日の授業を返す
Future<List<String>> dailyLessonSchedule(
    WidgetRef ref, DateTime selectTime) async {
  List<String> lessonName = [];
  //print(DateTime.now());

  List<dynamic> lessonData = await filterTimeTable(ref);

  for (var item in lessonData) {
    DateTime lessonTime = DateTime.parse(item['start']);

    if (selectTime.day == lessonTime.day) {
      lessonName.add(item['title']);
    }
    //else {
    //   print('selectday = $selectTime');
    //   print('lessonday = $lessonTime');
    // }
  }
  print(lessonName);

  return lessonName;
}
