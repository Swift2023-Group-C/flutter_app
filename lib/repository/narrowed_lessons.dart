import 'dart:convert';
import 'package:flutter_app/repository/read_json_file.dart';
import 'package:flutter_app/components/setting_user_info.dart';

// 時間割に設定している科目のlessonIdのリストを取得
Future<List<int>> loadPersonalTimeTableList() async {
  List<int> personalTimeTableList = [];

  final jsonString = await UserPreferences.getFinishList();
  if (jsonString != null) {
    personalTimeTableList = List<int>.from(json.decode(jsonString));
  }
  return personalTimeTableList;
}

// 施設予約のjsonファイルの中から取得している科目のみに絞り込み
Future<List<dynamic>> filterTimeTable() async {
  String fileName = 'map/oneweek_schedule.json';
  String jsonString = await readJsonFile(fileName);
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
Future<List<String>> dailyLessonSchedule(DateTime selectTime) async {
  List<String> lessonName = [];
  //print(DateTime.now());

  List<dynamic> lessonData = await filterTimeTable();

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
