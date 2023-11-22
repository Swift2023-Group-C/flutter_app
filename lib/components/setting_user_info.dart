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
  static const _keyGrade = 'grade';
  static const _keyCourse = 'course';
  static const _keyUserKey = 'userKey';
  static const _keyKadaiFinishListKey = 'finishListKey';
  static const _keyKadaiAlertListKey = 'alertListKey';
  static const _keyKadaiDeleteListKey = 'deleteListKey';
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

  static Future<void> setGrade(String grade) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGrade, grade);
  }

  static Future<String?> getGrade() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGrade);
  }

  static Future<void> setCourse(String course) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCourse, course);
  }

  static Future<String?> getCourse() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCourse);
  }

  static Future<void> setFinishList(String finishListString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyKadaiFinishListKey, finishListString);
  }

  static Future<String?> getFinishList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyKadaiFinishListKey);
  }

  static Future<void> setAlertList(String finishListString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyKadaiAlertListKey, finishListString);
  }

  static Future<String?> getAlertList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyKadaiAlertListKey);
  }

  static Future<void> setDeleteList(String finishListString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyKadaiDeleteListKey, finishListString);
  }

  static Future<String?> getDeleteList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyKadaiDeleteListKey);
  }

  static Future<void> setPersonalTimeTableList(
      String PersonalTimeTableString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _keyPersonalTimeTableListKey, PersonalTimeTableString);
  }

  static Future<String?> getPersonalTimeTableList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPersonalTimeTableListKey);
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

  static Future<String?> getUserKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserKey);
  }
}
