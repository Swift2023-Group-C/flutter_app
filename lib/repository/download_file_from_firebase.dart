import 'dart:io';
import 'dart:typed_data';
import 'package:dotto/repository/get_application_path.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> downloadFileFromFirebase(String firebaseFilePath) async {
  final gsReference =
      FirebaseStorage.instance.refFromURL("gs://swift2023groupc.appspot.com/$firebaseFilePath");

  final filePath = await getApplicationFilePath(firebaseFilePath);
  final file = File(filePath);

  bool doesFileExists = await file.exists();
  if (!doesFileExists) {
    file.create();
  }

  await gsReference.writeToFile(file);
}

Future<Uint8List?> getFileFromFirebase(String firebaseFilePath) async {
  final gsReference =
      FirebaseStorage.instance.refFromURL("gs://swift2023groupc.appspot.com/$firebaseFilePath");

  return await gsReference.getData();
}
