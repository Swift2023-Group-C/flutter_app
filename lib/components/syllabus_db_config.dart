import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SyllabusDBConfig {
  SyllabusDBConfig._internal();
  static final SyllabusDBConfig instance = SyllabusDBConfig._internal();
  static String dbPath = "";

  static Future<void> setDB() async {
    final dbDirectory = await getApplicationSupportDirectory();
    final dbFilePath = dbDirectory.path;
    final assetDbPath = join('assets', 'syllabus.db');
    final copiedDbPath = join(dbFilePath, 'syllabus.db');

    ByteData data = await rootBundle.load(assetDbPath);
    List<int> bytes = data.buffer.asUint8List();
    await File(copiedDbPath).writeAsBytes(bytes);
    dbPath = copiedDbPath;
  }
}
