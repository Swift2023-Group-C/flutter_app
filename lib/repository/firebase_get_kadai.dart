import 'package:flutter_app/components/kadai.dart';
import 'package:flutter_app/components/setting_user_info.dart';
import 'package:flutter_app/repository/get_firebase_realtime_db.dart';
import 'package:flutter_app/screens/kadai_list.dart';

class FirebaseGetKadai {
  const FirebaseGetKadai();
  Future<List<Kadai>> getKadaiFromFirebase() async {
    final String userKey =
        "swift2023c_hope_user_key_${await UserPreferences.getUserKey()}";
    List<Kadai> returnList = [];
    final snapshot =
        await GetFirebaseRealtimeDB.getData('hope/users/$userKey/data');
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      data.forEach((key, value) {
        returnList.add(Kadai.fromFirebase(key, value));
      });
    } else {
      print('No data available.');
      throw Exception();
    }
    return returnList;
  }
}
