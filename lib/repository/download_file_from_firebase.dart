import 'dart:io';
import 'package:flutter/material.dart';
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
        debugPrint("$firebaseFilePath downloading...");
        break;
      case TaskState.paused:
        break;
      case TaskState.success:
        debugPrint("$firebaseFilePath download success");
        break;
      case TaskState.canceled:
        break;
      case TaskState.error:
        debugPrint("$firebaseFilePath download error");
        break;
    }
  });
}
