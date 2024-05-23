import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<String> getApplicationFilePath(String path) async {
  final appDocDir = await getTemporaryDirectory();
  final splitPath = split(path);
  if (splitPath.length > 1) {
    String p = appDocDir.path;
    for (var i = 0; i < splitPath.length - 1; i++) {
      p += "/${splitPath[i]}";
      Directory d = Directory(p);
      if (!(await d.exists())) {
        d.create();
      }
    }
  }
  return "${appDocDir.path}/$path";
}
