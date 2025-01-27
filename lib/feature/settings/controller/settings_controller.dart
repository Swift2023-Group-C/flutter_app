import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/importer.dart';

FutureProvider<String> settingsGradeProvider = FutureProvider((ref) async {
  return await UserPreferences.getString(UserPreferenceKeys.grade) ?? 'なし';
});
FutureProvider<String> settingsCourseProvider = FutureProvider((ref) async {
  return await UserPreferences.getString(UserPreferenceKeys.course) ?? 'なし';
});
FutureProvider<String> settingsUserKeyProvider = FutureProvider((ref) async {
  return await UserPreferences.getString(UserPreferenceKeys.userKey) ?? '';
});
