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
    return json.decode(jsonString);
  }
  return [];
}

Future<void> savePersonalTimeTableList(
    List<int> personalTimeTableList, WidgetRef ref) async {
  await UserPreferences.setFinishList(json.encode(personalTimeTableList));
  final personalLessonIdListNotifier =
      ref.watch(personalLessonIdListProvider.notifier);
  personalLessonIdListNotifier.state = personalTimeTableList;
}

Future<List<dynamic>> filterTimeTable() async {
  String fileName = 'map/oneweek_schedule.json';
  String jsonString = await readJsonFile(fileName);
  List<dynamic> jsonData = json.decode(jsonString);
  //print(personalTimeTableList);

  List<dynamic> filteredData = [];
  for (int lessonId in _personalTimeTableList) {
    for (var item in jsonData) {
      if (item['lessonId'] == lessonId.toString()) {
        filteredData.add(item);
      }
    }
  }
  print(filteredData);
  return filteredData;
}
