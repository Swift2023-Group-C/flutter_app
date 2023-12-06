import 'dart:io';
import 'package:dotto/repository/get_application_path.dart';

Future<String> readJsonFile(String fileName) async {
  final filePath = await getApplicationFilePath(fileName);
  final file = File(filePath);

  // ファイルの存在確認
  if (await file.exists()) {
    // ファイルの内容を文字列として読み込む
    String content = await file.readAsString();
    //print("read success");
    return content;
  } else {
    throw Exception("File does not exist");
  }
}
