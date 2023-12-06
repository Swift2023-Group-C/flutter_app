import 'dart:io';

import 'package:flutter/services.dart';
import 'package:dotto/repository/get_application_path.dart';
import 'package:path/path.dart';

class SyllabusDBConfig {
  SyllabusDBConfig._internal();
  static final SyllabusDBConfig instance = SyllabusDBConfig._internal();
  static String dbPath = "";

  static Future<void> setDB() async {
    final assetDbPath = join('assets', 'syllabus.db');
    final copiedDbPath = await getApplicationFilePath('syllabus.db');

    ByteData data = await rootBundle.load(assetDbPath);
    List<int> bytes = data.buffer.asUint8List();
    await File(copiedDbPath).writeAsBytes(bytes);
    dbPath = copiedDbPath;
  }
}
