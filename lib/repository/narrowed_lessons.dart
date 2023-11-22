import 'dart:convert';
import 'package:flutter_app/repository/read_json_file.dart';
import 'package:flutter_app/components/setting_user_info.dart';

List<int> _personalTimeTableList = [];

Future<void> loadPersonalTimeTableList() async {
  final jsonString = await UserPreferences.getFinishList();
  if (jsonString != null) {
    _personalTimeTableList = List<int>.from(json.decode(jsonString));
  }
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
