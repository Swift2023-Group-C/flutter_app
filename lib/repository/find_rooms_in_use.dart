import 'dart:convert';

Map<String, List<String>> findRoomsInUse(String jsonString) {
  var decodedData = jsonDecode(jsonString);

  // JSONデータがリストでない場合はエラー
  if (decodedData is! List) {
    throw Exception("Expected a list of JSON objects");
  }

  Map<String, List<String>> resourceIds = {};
  DateTime now = DateTime.now();
  //DateTime now = DateTime(2023, 9, 25, 11, 30);
  print(now);

  for (var item in decodedData) {
    if (item is Map<String, dynamic>) {
      // スタート時間・エンド時間をDateTimeにかえる
      DateTime startTime = DateTime.parse(item['start']);
      DateTime endTime = DateTime.parse(item['end']);

      //現在時刻が開始時刻と終了時刻の間であればresourceIdを取得
      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        if (resourceIds.containsKey(item['resourceId'])) {
          resourceIds[item['resourceId']]!.add(item['lessonId']);
        } else {
          resourceIds.addAll({
            item['resourceId']: [item['lessonId']]
          });
        }
      }
    }
  }

  return resourceIds;
}
