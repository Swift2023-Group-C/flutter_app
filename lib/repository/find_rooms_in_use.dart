import 'dart:convert';

List<String> findRoomsInUse(String jsonString) {
  var decodedData = jsonDecode(jsonString);

  // JSONデータがリストでない場合はエラー
  if (decodedData is! List) {
    throw Exception("Expected a list of JSON objects");
  }

  List<String> resourceIds = [];
  DateTime now = DateTime.now();
  // print(now);

  for (var item in decodedData) {
    if (item is Map<String, dynamic>) {
      // スタート時間をエンド時間をDateTimeにかえる
      DateTime startTime = DateTime.parse(item['start']);
      DateTime endTime = DateTime.parse(item['end']);

      //現在時刻が開始時刻と終了時刻の間であればresourceIdを取得
      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        resourceIds.add(item['resourceId']);
      }
    }
  }

  return resourceIds;
}
