import 'package:dotto/importer.dart';
import 'package:geolocator/geolocator.dart';

Future<bool> requestLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 位置情報サービスが有効かどうかをテストします。
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // 位置情報サービスが有効でない場合、続行できません。
    // 位置情報にアクセスし、ユーザーに対して
    // 位置情報サービスを有効にするようアプリに要請する。
    debugPrint('Location services are disabled.');
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // ユーザーに位置情報を許可してもらうよう促す
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // 拒否された場合エラーを返す
      debugPrint('Location permissions are denied');
      return false;
    }
  }
  // 永久に拒否されている場合のエラーを返す
  if (permission == LocationPermission.deniedForever) {
    debugPrint('Location permissions are permanently denied, we cannot request permissions.');
    return false;
  }
  return true;
}

/// デバイスの現在位置を決定する。
/// 位置情報サービスが有効でない場合、または許可されていない場合、null
Future<Position?> determinePosition() async {
  if (await requestLocationPermission()) {
    return await Geolocator.getCurrentPosition();
  } else {
    return null;
  }
}
