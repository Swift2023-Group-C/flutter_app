import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyGrade = 'grade';
  static const _keyCourse = 'course';
  static const _keyUserKey = 'userKey';

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

  static Future<void> setUserKey(String userKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserKey, userKey);
  }

  static Future<String?> getUserKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserKey);
  }
}
