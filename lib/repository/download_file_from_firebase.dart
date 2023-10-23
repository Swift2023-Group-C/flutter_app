import 'dart:io';
import 'package:flutter_app/repository/get_application_path.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> downloadFileFromFirebase(String firebaseFilePath) async {
  final gsReference = FirebaseStorage.instance
      .refFromURL("gs://swift2023groupc.appspot.com/$firebaseFilePath");

  final filePath = await getApplicationFilePath(firebaseFilePath);
  final file = File(filePath);

  bool doesFileExists = await file.exists();
  if (!doesFileExists) {
    file.create();
  }

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
