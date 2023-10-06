import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/components/kadai.dart';
import '../components/setting_user_info.dart';

class FirebaseGetKadai {
  const FirebaseGetKadai();

  Future<List<Kadai>> getKadaiFromFirebase() async {
    final String? userKey = await UserPreferences.getUserKey();
    final FirebaseApp firebaseApp = Firebase.app();
    final ref = FirebaseDatabase.instanceFor(
            app: firebaseApp,
            databaseURL:
                "https://swift2023groupc-default-rtdb.asia-southeast1.firebasedatabase.app")
        .ref();
    List<Kadai> returnList = [];
    if (userKey != null) {
      final snapshot = await ref.child('hope/users/$userKey/data').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map;
        data.forEach((key, value) {
          returnList.add(Kadai.fromFirebase(key, value));
        });
      } else {
        print('No data available.');
      }
    }
    returnList.sort(((a, b) {
      if (a.endtime == null) {
        return 1;
      }
      if (b.endtime == null) {
        return -1;
      }
      return a.endtime!.compareTo(b.endtime!);
    }));
    return returnList;
  }
}
