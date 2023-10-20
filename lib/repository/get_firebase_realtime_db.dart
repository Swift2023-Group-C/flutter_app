import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class GetFirebaseRealtimeDB {
  const GetFirebaseRealtimeDB();

  static Future<DataSnapshot> getData(String path) async {
    final FirebaseApp firebaseApp = Firebase.app();
    final ref = FirebaseDatabase.instanceFor(
            app: firebaseApp,
            databaseURL:
                "https://swift2023groupc-default-rtdb.asia-southeast1.firebasedatabase.app")
        .ref();
    return await ref.child(path).get();
  }
}
