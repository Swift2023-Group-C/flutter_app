import 'package:path_provider/path_provider.dart';

Future<String> getApplicationFilePath(String path) async {
  final appDocDir = await getApplicationSupportDirectory();
  return "${appDocDir.path}/$path";
}
