import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> readFileContent() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = "${appDocDir.path}/oneweek_schedule.json";
  final file = File(filePath);

  // ファイルの存在確認
  if (await file.exists()) {
    // ファイルの内容を文字列として読み込む
    String content = await file.readAsString();
    return content;
  } else {
    throw Exception("File does not exist!");
  }
}
