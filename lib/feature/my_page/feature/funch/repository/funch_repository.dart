import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/feature/my_page/feature/funch/controller/funch_controller.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/read_json_file.dart';

class FunchRepository {
  static final FunchRepository _instance = FunchRepository._internal();
  factory FunchRepository() {
    return _instance;
  }
  FunchRepository._internal();

  Future<Map<DateTime, List<int>>> getDaysMenuFromFirestore() async {
    final data = await FirebaseFirestore.instance.collection('funch_day').orderBy("date").get();
    Map<DateTime, List<int>> map = {};
    for (var element in data.docs) {
      final dayData = element.data();
      if (dayData.containsKey("menu") && dayData.containsKey("date")) {
        try {
          final date = (dayData["date"] as Timestamp).toDate();
          final newDate = DateTime(date.year, date.month, date.day);
          final menu = dayData["menu"] as List<int>;
          map[newDate] = menu;
        } catch (e) {
          continue;
        }
      }
    }
    return map;
  }

  Future<List<FunchMenu>> getAllMenu() async {
    String fileName = 'funch/menu.json';
    String jsonString = await readJsonFile(fileName);
    List<dynamic> jsonData = json.decode(jsonString);

    return jsonData.map((e) => FunchMenu.fromMenuJson(e)).toList();
  }

  Future<Map<DateTime, List<FunchMenu>>> getDaysMenu(WidgetRef ref) async {
    final allMenu = ref.watch(funchAllMenuProvider);
    if (allMenu != null) {
      final data = await getDaysMenuFromFirestore();
      return data.map((key, value) {
        final list =
            value.map((v) => allMenu.firstWhere((element) => element.itemCode == v)).toList();
        return MapEntry(key, list);
      });
    } else {
      return {};
    }
  }

  List<FunchMenu> get1DayMenu(DateTime dateTime, WidgetRef ref) {
    final data = ref.watch(funchDaysMenuProvider);
    if (data == null) return [];
    if (data.containsKey(dateTime)) return [];
    return data[dateTime]!;
  }
}