import 'package:shared_preferences/shared_preferences.dart';

enum UserPreferenceKeys {
  grade(keyName: 'grade', type: String),
  course(keyName: 'course', type: String),
  userKey(keyName: 'userKey', type: String),
  kadaiFinishList(keyName: 'finishListKey', type: String),
  kadaiAlertList(keyName: 'alertListKey', type: String),
  kadaiDeleteList(keyName: 'deleteListKey', type: String),
  personalTimetableListKey(keyName: 'personalTimeTableListKey', type: String),
  isAppTutorialComplete(keyName: 'isAppTutorialCompleted', type: bool),
  isKadaiTutorialComplete(keyName: 'isKadaiTutorialCompleted', type: bool);

  const UserPreferenceKeys({
    required this.keyName,
    required this.type,
  });
  final String keyName;
  final Type type;
}

class UserPreferences {
  static const _keyPersonalTimeTableListKey = 'personalTimeTableListKey';

  static Future<void> setBool(UserPreferenceKeys key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key.type == bool) {
      await prefs.setBool(key.keyName, value);
    } else {
      throw TypeError();
    }
  }

  static Future<bool?> getBool(UserPreferenceKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key.keyName);
  }

  static Future<void> setString(UserPreferenceKeys key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key.type == String) {
      await prefs.setString(key.keyName, value);
    } else {
      throw TypeError();
    }
  }

  static Future<String?> getString(UserPreferenceKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key.keyName);
  }

  // 半角英数16桁の正規表現パターン
  static final RegExp _userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');

  // ユーザーキーを保存する前にチェックを行う
  static Future<void> setUserKey(String userKey) async {
    if (!_isValidUserKey(userKey)) {
      throw ArgumentError(
          'Invalid userKey format. It should be 16 alphanumeric characters.');
    }

    await setString(UserPreferenceKeys.userKey, userKey);
  }

  // ユーザーキーが正しいフォーマットかどうかをチェック
  static bool _isValidUserKey(String userKey) {
    return _userKeyPattern.hasMatch(userKey);
  }
}
