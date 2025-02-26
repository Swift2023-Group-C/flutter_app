import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dotto/feature/my_page/feature/funch/controller/funch_controller.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_price.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/read_json_file.dart';

class FunchRepository {
  static final FunchRepository _instance = FunchRepository._internal();
  factory FunchRepository() {
    return _instance;
  }
  FunchRepository._internal();

  DateTime nextDay() {
    final today = DateTime.now();
    if (today.weekday >= 6) {
      return DateTime(today.year, today.month, today.day + 8 - today.weekday);
    }
    if (today.hour > 13) {
      return DateTime(today.year, today.month, today.day + 1);
    }
    return DateTime(today.year, today.month, today.day);
  }

  Future<List<FunchCoopMenu>> getAllCoopMenu() async {
    String fileName = 'funch/menu.json';
    String jsonString = await readJsonFile(fileName);
    List<dynamic> jsonData = json.decode(jsonString);

    return jsonData.map((e) => FunchCoopMenu.fromMenuJson(e)).toList();
  }

  Future<Map<DateTime, Map>> _getDaysMenuFromFirestore() async {
    final daysMenuRef = FirebaseFirestore.instance.collection('funch_day');
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    final query = daysMenuRef
        .where("date", isGreaterThan: Timestamp.fromDate(yesterday))
        .where("date", isLessThan: Timestamp.fromDate(yesterday.add(Duration(days: 7))));
    final data = await query.get();
    Map<DateTime, Map> map = {};
    for (var element in data.docs) {
      final dayData = element.data();
      if (dayData.containsKey("menu") &&
          dayData.containsKey("date") &&
          dayData.containsKey("original_menu")) {
        try {
          final date = (dayData["date"] as Timestamp).toDate();
          final newDate = DateTime(date.year, date.month, date.day);
          final menu = (dayData["menu"] as List<dynamic>).map((item) => item as int).toList();
          final originalMenu = (dayData["original_menu"] as List<dynamic>)
              .map((item) => item as DocumentReference)
              .toList();
          map[newDate] = {
            "menu": menu,
            "original_menu": originalMenu,
          };
        } catch (e) {
          continue;
        }
      }
    }
    return map;
  }

  Future<List<FunchOriginalPrice>> _getAllOriginalPriceFromFirestore() async {
    final priceRef = FirebaseFirestore.instance.collection('funch_price');
    final data = await priceRef.get();
    return data.docs.map((e) {
      final map = e.data();
      return FunchOriginalPrice(map["large"], map["medium"], map["small"], e.id,
          (map["categories"] is List ? List<int>.from(map["categories"]) : <int>[]));
    }).toList();
  }

  Future<List<FunchOriginalMenu>> _getAllOriginalMenu(Set<String> originalMenuRefs) async {
    final originalMenuRef = FirebaseFirestore.instance.collection('funch_original_menu');
    final data = await originalMenuRef.get();
    final allOriginalPrice = await _getAllOriginalPriceFromFirestore();
    return data.docs.map((e) {
      final map = e.data();
      final price = allOriginalPrice
          .firstWhere((element) => element.id == (map["price"] as DocumentReference).id);
      return FunchOriginalMenu(
          e.id, map["title"], price, map["category"], map["image"], map["energy"]);
    }).toList();
  }

  Future<Map<DateTime, FunchDaysMenu>> getDaysMenu(Ref ref, List<FunchCoopMenu>? allMenu) async {
    if (allMenu != null) {
      final data = await _getDaysMenuFromFirestore();
      Set<String> originalMenuRefs = {};
      for (var key in data.keys) {
        originalMenuRefs
            .addAll((data[key]!["original_menu"] as List<DocumentReference>).map((e) => e.id));
      }
      final originalMenu = await _getAllOriginalMenu(originalMenuRefs);
      ref.read(funchAllOriginalMenuProvider.notifier).set(originalMenu);

      return data.map((key, value) {
        List<FunchCoopMenu> list = [];
        for (int v in value["menu"]) {
          final menu = allMenu.firstWhereOrNull((element) => element.itemCode == v);
          if (menu != null) {
            list.add(menu);
          }
        }
        List<FunchOriginalMenu> originalList = [];
        for (DocumentReference v in value["original_menu"]) {
          final menu = originalMenu.firstWhereOrNull((element) => element.id == v.id);
          if (menu != null) {
            originalList.add(menu);
          }
        }
        return MapEntry(key, FunchDaysMenu(key, list, originalList));
      });
    } else {
      return {};
    }
  }

  Future<Map<int, Map>> _getMonthMenuFromFirestore() async {
    final monthMenuRef = FirebaseFirestore.instance.collection('funch_month');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final days6 = today.add(Duration(days: 6));
    final query =
        monthMenuRef.where("year", isEqualTo: today.year).where("month", isEqualTo: today.month);
    final queries = [query];
    if (today.month != days6.month) {
      queries.add(
          monthMenuRef.where("year", isEqualTo: days6.year).where("month", isEqualTo: days6.month));
    }
    final data = await Future.wait(queries.map((e) => e.get()));
    Map<int, Map> map = {};
    for (var element in data) {
      final docs = element.docs;
      if (docs.isEmpty) continue;
      final dayData = element.docs.first.data();
      if (dayData.containsKey("menu") &&
          dayData.containsKey("month") &&
          dayData.containsKey("original_menu")) {
        try {
          final month = dayData["month"] as int;
          final menu = (dayData["menu"] as List<dynamic>).map((item) => item as int).toList();
          final originalMenu = (dayData["original_menu"] as List<dynamic>)
              .map((item) => item as DocumentReference)
              .toList();
          map[month] = {
            "menu": menu,
            "original_menu": originalMenu,
          };
        } catch (e) {
          continue;
        }
      }
    }
    return map;
  }

  Future<Map<int, FunchMonthMenu>> getMonthMenu(Ref ref, List<FunchCoopMenu>? allMenu) async {
    if (allMenu != null) {
      final data = await _getMonthMenuFromFirestore();
      Set<String> originalMenuRefs = {};
      for (var key in data.keys) {
        originalMenuRefs
            .addAll((data[key]!["original_menu"] as List<DocumentReference>).map((e) => e.id));
      }
      final originalMenu = await _getAllOriginalMenu(originalMenuRefs);

      return data.map((key, value) {
        List<FunchCoopMenu> list = [];
        for (int v in value["menu"]) {
          final menu = allMenu.firstWhereOrNull((element) => element.itemCode == v);
          if (menu != null) {
            list.add(menu);
          }
        }
        List<FunchOriginalMenu> originalList = [];
        for (DocumentReference v in value["original_menu"]) {
          final menu = originalMenu.firstWhereOrNull((element) => element.id == v.id);
          if (menu != null) {
            originalList.add(menu);
          }
        }
        return MapEntry(key, FunchMonthMenu(key, list, originalList));
      });
    } else {
      return {};
    }
  }

  Future<FunchDaysMenu?> get1DayMenu(DateTime dateTime, WidgetRef ref) async {
    final data = await ref.watch(funchDaysMenuProvider);
    if (!data.containsKey(dateTime)) return null;
    return data[dateTime]!;
  }
}
