import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyGrade = 'grade';
  static const _keyCourse = 'course';
  static const _keyUserKey = 'userKey';
  static const _keyKadaiFinishListKey = 'finishListKey';
  static const _keyKadaiAlertListKey = 'alertListKey';
  static const _keyKadaiDeleteListKey = 'deleteListKey';

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

  // 半角英数16桁の正規表現パターン
  static final RegExp _userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');

  // ユーザーキーを保存する前にチェックを行う
  static Future<void> setUserKey(String userKey) async {
    if (!_isValidUserKey(userKey)) {
      throw ArgumentError(
          'Invalid userKey format. It should be 16 alphanumeric characters.');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserKey, userKey);
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
