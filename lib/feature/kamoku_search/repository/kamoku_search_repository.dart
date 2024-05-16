import 'package:sqflite/sqflite.dart';

import 'package:dotto/components/db_config.dart';

class KamokuSearchRepository {
  static final KamokuSearchRepository _instance =
      KamokuSearchRepository._internal();
  factory KamokuSearchRepository() {
    return _instance;
  }
  KamokuSearchRepository._internal();

  Future<List<Map<String, dynamic>>> fetchWeekPeriodDB(
      List<int> lessonIdList) async {
    Database database = await openDatabase(SyllabusDBConfig.dbPath);

    List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT * FROM week_period where lessonId in (${lessonIdList.join(',')})');
    return records;
  }
}
