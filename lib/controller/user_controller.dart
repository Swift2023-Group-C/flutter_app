import 'package:dotto/importer.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userProvider = NotifierProvider<UserNotifier, User?>(() {
  return UserNotifier();
});

class UserNotifier extends Notifier<User?> {
  @override
  User? build() {
    return FirebaseAuth.instance.currentUser;
  }

  void login(User user) {
    state = user;
  }

  void logout() {
    state = null;
  }

  bool get isLoggedin {
    return state != null;
  }
}
