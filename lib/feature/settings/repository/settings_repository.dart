import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/feature/my_page/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/settings/controller/settings_controller.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingsRepository {
  static final SettingsRepository _instance = SettingsRepository._internal();
  factory SettingsRepository() {
    return _instance;
  }
  SettingsRepository._internal();

  Future<void> setUserKey(String userKey, WidgetRef ref) async {
    final RegExp userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');
    if (userKey.length == 16) {
      if (userKeyPattern.hasMatch(userKey)) {
        await UserPreferences.setString(UserPreferenceKeys.userKey, userKey);
        ref.invalidate(settingsUserKeyProvider);
      }
    } else if (userKey.isEmpty) {
      await UserPreferences.setString(UserPreferenceKeys.userKey, userKey);
      ref.invalidate(settingsUserKeyProvider);
    }
  }

  Future<void> saveFCMToken(User user) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      final db = FirebaseFirestore.instance;
      final tokenRef = db.collection("fcm_token");
      final tokenQuery =
          tokenRef.where('uid', isEqualTo: user.uid).where('token', isEqualTo: fcmToken);
      final tokenQuerySnapshot = await tokenQuery.get();
      final tokenDocs = tokenQuerySnapshot.docs;
      if (tokenDocs.isEmpty) {
        await tokenRef.add({
          'uid': user.uid,
          'token': fcmToken,
          'last_updated': Timestamp.now(),
        });
      }
      UserPreferences.setBool(UserPreferenceKeys.didSaveFCMToken, true);
    }
  }

  Future<void> onLogin(BuildContext context, Function login, WidgetRef ref) async {
    final user = await FirebaseAuthRepository().signIn();
    if (user != null) {
      login(user);
      saveFCMToken(user);
      if (context.mounted) {
        await TimetableRepository().loadPersonalTimeTableListOnLogin(context, ref);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ログインできませんでした。')),
        );
      }
    }
  }

  Future<void> onLogout(Function logout) async {
    await FirebaseAuthRepository().signOut();
    logout();
  }
}
