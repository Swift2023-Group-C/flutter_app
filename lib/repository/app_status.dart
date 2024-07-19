import 'package:firebase_auth/firebase_auth.dart';

class AppStatus {
  static final AppStatus _instance = AppStatus._internal();
  factory AppStatus() {
    return _instance;
  }
  AppStatus._internal();

  bool get isLoggedinGoogle {
    return FirebaseAuth.instance.currentUser != null;
  }
}
