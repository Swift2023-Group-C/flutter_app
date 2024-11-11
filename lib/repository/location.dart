import 'package:dotto/importer.dart';
import 'package:geolocator/geolocator.dart';

Future<bool> requestLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // 有効でない場合、ユーザーに対して有効にするようアプリに要請
    debugPrint('Location services are disabled.');
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // ユーザーに位置情報を許可してもらうよう促す
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
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

/// 位置情報サービスが有効でない場合、または許可されていない場合、null
Future<Position?> determinePosition() async {
  if (await requestLocationPermission()) {
    return await Geolocator.getCurrentPosition();
  } else {
    return null;
  }
}
