import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/feature/settings/controller/settings_controller.dart';
import 'package:dotto/importer.dart';

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
}
