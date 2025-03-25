import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:sqflite/sqflite.dart';

import 'package:dotto/importer.dart';
import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/feature/my_page/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/feature/my_page/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/repository/db_config.dart';
import 'package:dotto/repository/read_json_file.dart';

class TimetableRepository {
  static final TimetableRepository _instance = TimetableRepository._internal();
  factory TimetableRepository() {
    return _instance;
  }
  TimetableRepository._internal();

  final db = FirebaseFirestore.instance;

// 月曜から次の週の日曜までの日付を返す
  List<DateTime> getDateRange() {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    // 月曜
    var startDate = today.subtract(Duration(days: today.weekday - 1));

    List<DateTime> dates = [];
    for (int i = 0; i < 14; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }

    return dates;
  }

  Future<Map<String, dynamic>?> fetchDB(int lessonId) async {
    Database database = await openDatabase(SyllabusDBConfig.dbPath);

    List<Map<String, dynamic>> records = await database
        .rawQuery('SELECT LessonId, 過去問, 授業名 FROM sort where LessonId = ?', [lessonId]);
    if (records.isEmpty) {
      return null;
    }
    return records.first;
  }

  Future<List<String>> getLessonNameList(List<int> lessonIdList) async {
    Database database = await openDatabase(SyllabusDBConfig.dbPath);

    List<Map<String, dynamic>> records = await database
        .rawQuery('SELECT 授業名 FROM sort WHERE LessonId in (${lessonIdList.join(",")})');
    List<String> lessonNameList = records.map((e) => e['授業名'] as String).toList();
    return lessonNameList;
  }

  Future<List<int>> loadLocalPersonalTimeTableList() async {
    final jsonString = await UserPreferences.getString(UserPreferenceKeys.personalTimetableListKey);
    if (jsonString != null) {
      return List<int>.from(json.decode(jsonString));
    }
    return [];
  }

  Future<void> loadPersonalTimeTableListOnLogin(BuildContext context, WidgetRef ref) async {
    final user = ref.read(userProvider);
    if (user == null) {
      return;
    }
    List<int> personalTimeTableList = [];
    final doc = db.collection('user_taking_course').doc(user.uid);
    final docSnapshot = await doc.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        final firestoreLastUpdated = data['last_updated'] as Timestamp;
        final localLastUpdated =
            await UserPreferences.getInt(UserPreferenceKeys.personalTimetableLastUpdateKey) ?? 0;
        final diff = localLastUpdated - firestoreLastUpdated.millisecondsSinceEpoch;
        final firestoreList = List<int>.from(data['2025']);
        final localList = await loadLocalPersonalTimeTableList();
        if (localList.isEmpty) {
          personalTimeTableList = firestoreList;
        } else if (firestoreList.isEmpty) {
          personalTimeTableList = localList;
          savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
        } else if (diff.abs() > 300000) {
          final firestoreSet = firestoreList.toSet();
          final localSet = localList.toSet();
          // firestoreList と locallist のIDが同じかどうか確認
          if (firestoreSet.containsAll(localSet) && localSet.containsAll(firestoreSet)) {
            personalTimeTableList = firestoreList;
          } else {
            // LessonName取得
            final firestoreLessonNameList =
                await getLessonNameList(firestoreSet.difference(localSet).toList());
            final localLessonNameList =
                await getLessonNameList(localSet.difference(firestoreSet).toList());
            if (context.mounted) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('データの同期'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text('アカウントに紐づいている時間割とローカルの時間割が異なっています。どちらを残しますか？'),
                          Text('-- アカウント側に多い科目 --'),
                          ...firestoreLessonNameList.map((e) => Text(e.toString())),
                          const SizedBox(height: 10),
                          Text('-- ローカル側に多い科目 --'),
                          ...localLessonNameList.map((e) => Text(e.toString())),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          personalTimeTableList = firestoreList;
                          Navigator.of(context).pop();
                        },
                        child: const Text('アカウント方を残す'),
                      ),
                      TextButton(
                        onPressed: () async {
                          personalTimeTableList = localList;
                          savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
                          Navigator.of(context).pop();
                        },
                        child: const Text('ローカル方を残す'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        } else {
          personalTimeTableList = firestoreList;
        }
      } else {
        personalTimeTableList = await loadLocalPersonalTimeTableList();
        savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
      }
    } else {
      personalTimeTableList = await loadLocalPersonalTimeTableList();
      savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
    }
  }

  Future<List<int>> loadPersonalTimeTableList(WidgetRef ref) async {
    final user = ref.read(userProvider);
    List<int> personalTimeTableList = [];
    if (user == null) {
      Timer(const Duration(seconds: 1), () {});
      personalTimeTableList = await loadLocalPersonalTimeTableList();
    } else {
      final doc = db.collection('user_taking_course').doc(user.uid);
      final docSnapshot = await doc.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          final firestoreLastUpdated = data['last_updated'] as Timestamp;
          final localLastUpdated =
              await UserPreferences.getInt(UserPreferenceKeys.personalTimetableLastUpdateKey) ?? 0;
          final diff = localLastUpdated - firestoreLastUpdated.millisecondsSinceEpoch;
          final firestoreList = List<int>.from(data['2025']);
          final localList = await loadLocalPersonalTimeTableList(); // ここなぜか取得できない
          if (localList.isEmpty) {
            personalTimeTableList = firestoreList;
          } else if (firestoreList.isEmpty || diff > 600000) {
            personalTimeTableList = localList;
            savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
          } else {
            personalTimeTableList = firestoreList;
          }
        } else {
          personalTimeTableList = await loadLocalPersonalTimeTableList();
          savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
        }
      } else {
        personalTimeTableList = await loadLocalPersonalTimeTableList();
        savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
      }
    }
    await savePersonalTimeTableList(personalTimeTableList, ref);
    return personalTimeTableList;
  }

  Future<void> addPersonalTimeTableListToFirestore(int lessonId, WidgetRef ref) async {
    final user = ref.read(userProvider);
    if (user == null) {
      return;
    }
    final doc = db.collection('user_taking_course').doc(user.uid);
    await doc.update({
      '2025': FieldValue.arrayUnion([lessonId]),
      'last_updated': FieldValue.serverTimestamp(),
    });
    // .onError((error, stackTrace) async {
    //   await savePersonalTimeTableListToFirestore(ref);
    // });
  }

  Future<void> removePersonalTimeTableListFromFirestore(int lessonId, WidgetRef ref) async {
    final user = ref.read(userProvider);
    if (user == null) {
      return;
    }
    final doc = db.collection('user_taking_course').doc(user.uid);
    await doc.update({
      '2025': FieldValue.arrayRemove([lessonId]),
      'last_updated': FieldValue.serverTimestamp(),
    });
    // .onError((error, stackTrace) async {
    //   await savePersonalTimeTableListToFirestore(ref);
    // });
  }

  Future<void> savePersonalTimeTableListToFirestore(
      List<int> personalTimeTableList, WidgetRef ref) async {
    final user = ref.read(userProvider);
    if (user == null) {
      return;
    }
    final doc = db.collection('user_taking_course').doc(user.uid);
    await doc.set({
      '2025': personalTimeTableList,
      'last_updated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> savePersonalTimeTableList(List<int> personalTimeTableList, WidgetRef ref) async {
    ref.read(personalLessonIdListProvider.notifier).set(personalTimeTableList);
  }

  Future<void> addPersonalTimeTableList(int lessonId, WidgetRef ref) async {
    ref.read(personalLessonIdListProvider.notifier).add(lessonId);
    await addPersonalTimeTableListToFirestore(lessonId, ref);
  }

  Future<void> removePersonalTimeTableList(int lessonId, WidgetRef ref) async {
    ref.read(personalLessonIdListProvider.notifier).remove(lessonId);
    await removePersonalTimeTableListFromFirestore(lessonId, ref);
  }

  Future<Map<String, int>> loadPersonalTimeTableMapString(WidgetRef ref) async {
    List<int> personalTimeTableListInt = await ref.read(personalLessonIdListProvider);

    Database database = await openDatabase(SyllabusDBConfig.dbPath);
    Map<String, int> loadPersonalTimeTableMap = {};
    List<Map<String, dynamic>> records = await database.rawQuery(
        'select LessonId, 授業名 from sort where LessonId in (${personalTimeTableListInt.join(",")})');
    for (var record in records) {
      String lessonName = record['授業名'];
      int lessonId = record['LessonId'];
      loadPersonalTimeTableMap[lessonName] = lessonId;
    }
    return loadPersonalTimeTableMap;
  }

  // 施設予約のjsonファイルの中から取得している科目のみに絞り込み
  Future<List<dynamic>> filterTimeTable(WidgetRef ref) async {
    String fileName = 'map/oneweek_schedule.json';
    try {
      String jsonString = await readJsonFile(fileName);
      List<dynamic> jsonData = json.decode(jsonString);

      List<int> personalTimeTableList = await ref.read(personalLessonIdListProvider);

      List<dynamic> filteredData = [];
      for (int lessonId in personalTimeTableList) {
        for (var item in jsonData) {
          if (item['lessonId'] == lessonId.toString()) {
            filteredData.add(item);
          }
        }
      }
      return filteredData;
    } catch (e) {
      return [];
    }
  }

  Future<Map<DateTime, Map<int, List<TimeTableCourse>>>> get2WeekLessonSchedule(
      WidgetRef ref) async {
    final List<DateTime> dates = getDateRange();
    Map<DateTime, Map<int, List<TimeTableCourse>>> twoWeekLessonSchedule = {};
    try {
      for (var date in dates) {
        twoWeekLessonSchedule[date] = await dailyLessonSchedule(date, ref);
      }
      return twoWeekLessonSchedule;
    } catch (e) {
      return twoWeekLessonSchedule;
    }
  }

// 時間を入れたらその日の授業を返す
  Future<Map<int, List<TimeTableCourse>>> dailyLessonSchedule(
      DateTime selectTime, WidgetRef ref) async {
    Map<int, Map<int, TimeTableCourse>> periodData = {1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}};
    Map<int, List<TimeTableCourse>> returnData = {};

    List<dynamic> lessonData = await filterTimeTable(ref);

    for (var item in lessonData) {
      DateTime lessonTime = DateTime.parse(item['start']);

      if (selectTime.day == lessonTime.day) {
        int period = item['period'];
        int lessonId = int.parse(item['lessonId']);
        List<int> resourceId = [];
        try {
          resourceId.add(int.parse(item['resourceId']));
        } catch (e) {
          // resourceIdが空白
        }
        if (periodData.containsKey(period)) {
          if (periodData[period]!.containsKey(lessonId)) {
            periodData[period]![lessonId]!.resourseIds.addAll(resourceId);
            continue;
          }
        }
        periodData[period]![lessonId] = TimeTableCourse(lessonId, item['title'], resourceId);
      }
    }

    String jsonData = await readJsonFile('home/cancel_lecture.json');
    List<dynamic> cancelLectureData = jsonDecode(jsonData);
    jsonData = await readJsonFile('home/sup_lecture.json');
    List<dynamic> supLectureData = jsonDecode(jsonData);
    Map<String, int> loadPersonalTimeTableMap = await loadPersonalTimeTableMapString(ref);

    for (var cancelLecture in cancelLectureData) {
      DateTime dt = DateTime.parse(cancelLecture['date']);
      if (dt.month == selectTime.month && dt.day == selectTime.day) {
        String lessonName = cancelLecture['lessonName'];
        if (loadPersonalTimeTableMap.containsKey(lessonName)) {
          int lessonId = loadPersonalTimeTableMap[lessonName]!;
          periodData[cancelLecture['period']]![lessonId] =
              TimeTableCourse(lessonId, lessonName, [], cancel: true);
        }
      }
    }

    for (var supLecture in supLectureData) {
      DateTime dt = DateTime.parse(supLecture['date']);
      if (dt.month == selectTime.month && dt.day == selectTime.day) {
        String lessonName = supLecture['lessonName'];
        if (loadPersonalTimeTableMap.containsKey(lessonName)) {
          int lessonId = loadPersonalTimeTableMap[lessonName]!;
          periodData[supLecture['period']]![lessonId]!.sup = true;
        }
      }
    }
    periodData.forEach((key, value) {
      returnData[key] = value.values.toList();
    });
    return returnData;
  }

  Future<List<Map<String, dynamic>>> fetchRecords() async {
    Database database = await openDatabase(SyllabusDBConfig.dbPath);

    List<Map<String, dynamic>> records =
        await database.rawQuery('SELECT * FROM week_period order by lessonId');
    return records;
  }

  Future<bool> isOverSeleted(int lessonId, WidgetRef ref) async {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);
    final weekPeriodAllRecords = ref.watch(weekPeriodAllRecordsProvider).value;
    if (weekPeriodAllRecords != null) {
      final filterWeekPeriod =
          weekPeriodAllRecords.where((element) => element['lessonId'] == lessonId).toList();
      List<Map<String, dynamic>> targetWeekPeriod =
          filterWeekPeriod.where((element) => element['開講時期'] != 0).toList();
      for (var element in filterWeekPeriod.where((element) => element['開講時期'] == 0)) {
        Map<String, dynamic> e1 = {...element};
        Map<String, dynamic> e2 = {...element};
        e1['開講時期'] = 10;
        e2['開講時期'] = 20;
        targetWeekPeriod.addAll([e1, e2]);
      }
      Set<int> removeLessonIdList = {};
      bool flag = false;
      for (var record in targetWeekPeriod) {
        final int term = record['開講時期'];
        final int week = record['week'];
        final int period = record['period'];
        List<Map<String, dynamic>> selectedLessonList = weekPeriodAllRecords.where((record) {
          return record['week'] == week &&
              record['period'] == period &&
              (record['開講時期'] == term || record['開講時期'] == 0) &&
              personalLessonIdList.contains(record['lessonId']);
        }).toList();
        if (selectedLessonList.length > 1) {
          final removeLessonList = selectedLessonList.sublist(2, selectedLessonList.length);
          if (removeLessonList.isNotEmpty) {
            removeLessonIdList.addAll(removeLessonList.map((e) => e['lessonId'] as int).toSet());
          }
          flag = true;
        }
      }
      if (removeLessonIdList.isNotEmpty) {
        personalLessonIdList.removeWhere((element) => removeLessonIdList.contains(element));
        await savePersonalTimeTableList(personalLessonIdList, ref);
      }
      return flag;
    }
    return true;
  }
}
