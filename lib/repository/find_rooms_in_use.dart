import 'dart:convert';

/*
String toJson(Map<String, dynamic> data) {
  return jsonEncode(data);
}
*/

List<String> getResourceId(String jsonString) {
  var decodedData = jsonDecode(jsonString);

  // JSONデータがリストでない場合はエラーをスロー
  if (decodedData is! List) {
    throw Exception("Expected a list of JSON objects");
  }

  List<String> resourceIds = [];
  DateTime now = DateTime.now();

  for (var item in decodedData) {
    if (item is Map<String, dynamic>) {
      DateTime startTime = DateTime.parse(item['start']);
      DateTime endTime = DateTime.parse(item['end']);

      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        resourceIds.add(item['resourceId']);
      }
    }
  }

  return resourceIds;
}
