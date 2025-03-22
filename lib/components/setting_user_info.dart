import 'package:shared_preferences/shared_preferences.dart';

enum UserPreferenceKeys {
  grade(keyName: 'grade', type: String),
  course(keyName: 'course', type: String),
  userKey(keyName: 'userKey', type: String),
  kadaiFinishList(keyName: 'finishListKey', type: String),
  kadaiAlertList(keyName: 'alertListKey', type: String),
  kadaiDeleteList(keyName: 'deleteListKey', type: String),
  personalTimetableListKey(keyName: 'personalTimeTableListKey2025', type: String),
  personalTimetableLastUpdateKey(keyName: 'personalTimeTableLastUpdateKey', type: int),
  isAppTutorialComplete(keyName: 'isAppTutorialCompleted', type: bool),
  isKadaiTutorialComplete(keyName: 'isKadaiTutorialCompleted', type: bool),
  myBusStop(keyName: 'myBusStop', type: int),
  didSaveFCMToken(keyName: 'didSaveFCMToken', type: bool);

  const UserPreferenceKeys({
    required this.keyName,
    required this.type,
  });
  final String keyName;
  final Type type;
}

class UserPreferences {
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

  static Future<void> setInt(UserPreferenceKeys key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key.type == int) {
      await prefs.setInt(key.keyName, value);
    } else {
      throw TypeError();
    }
  }

  static Future<int?> getInt(UserPreferenceKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key.keyName);
  }

  // 半角英数16桁の正規表現パターン
  static final RegExp _userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');

  // ユーザーキーを保存する前にチェックを行う
  static Future<bool> setUserKey(String userKey) async {
    if (!_isValidUserKey(userKey)) {
      return false;
    }

    await setString(UserPreferenceKeys.userKey, userKey);
    return true;
  }

  // ユーザーキーが正しいフォーマットかどうかをチェック
  static bool _isValidUserKey(String userKey) {
    return _userKeyPattern.hasMatch(userKey);
  }
}
