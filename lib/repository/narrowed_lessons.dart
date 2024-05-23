import 'dart:convert';
import 'package:dotto/feature/my_page/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/components/setting_user_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> savePersonalTimeTableList(
    List<int> personalTimeTableList, WidgetRef ref) async {
  await UserPreferences.setString(UserPreferenceKeys.personalTimetableListKey,
      json.encode(personalTimeTableList));
  final personalLessonIdListNotifier =
      ref.watch(personalLessonIdListProvider.notifier);
  personalLessonIdListNotifier.state = [...personalTimeTableList];
}
