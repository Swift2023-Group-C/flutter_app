import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/components/kadai.dart';

class FirebaseGetKadai {
  const FirebaseGetKadai(this.userKey);
  final String userKey;

  Future<List<Kadai>> getKadaiFromFirebase() async {
    final FirebaseApp firebaseApp = Firebase.app();
    final ref = FirebaseDatabase.instanceFor(
            app: firebaseApp,
            databaseURL:
                "https://swift2023groupc-default-rtdb.asia-southeast1.firebasedatabase.app")
        .ref();
    final snapshot = await ref.child('hope/users/$userKey/data').get();
    List<Kadai> returnList = [];
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      data.forEach((key, value) {
        returnList.add(Kadai.fromFirebase(key, value));
      });
    } else {
      print('No data available.');
    }
    return returnList;
  }
}
