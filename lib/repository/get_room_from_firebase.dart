import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

downloadFileFromFirebase() async {
  final gsReference = FirebaseStorage.instance
      .refFromURL("gs://swift2023groupc.appspot.com/map/oneweek_schedule.json");

  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = "${appDocDir.path}/oneweek_schedule.json";

  final file = File(filePath);

  final downloadTask = gsReference.writeToFile(file);

  downloadTask.snapshotEvents.listen((taskSnapshot) {
    switch (taskSnapshot.state) {
      case TaskState.running:
        // TODO: Handle this case.
        break;
      case TaskState.paused:
        // TODO: Handle this case.
        break;
      case TaskState.success:
        print("success");
        break;
      case TaskState.canceled:
        // TODO: Handle this case.
        break;
      case TaskState.error:
        print("error");
        break;
    }
  });
}



/*
String toJson(Map<String, dynamic> data) {
  return jsonEncode(data);
}
*/

/*
String getResourceId(String jsonString) {
  Map<String, dynamic> decodedData = jsonDecode(jsonString);
  DateTime startTime = DateTime.parse(decodedData['start']);
  print(startTime);
  DateTime endTime = DateTime.parse(decodedData['end']);
  DateTime now = DateTime.now().toUtc();
  print(now);

  if (now.isAfter(startTime) && now.isBefore(endTime)) {
    return decodedData['resourceId'];
  } else {
    return "not exist";
  }
  */
