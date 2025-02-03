import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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

  Future<Map<DateTime, Map>> getDaysMenuFromFirestore() async {
    final daysMenuRef = FirebaseFirestore.instance.collection('funch_day');
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    final query = daysMenuRef
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(yesterday))
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

  Future<List<FunchCoopMenu>> getAllCoopMenu() async {
    String fileName = 'funch/menu.json';
    String jsonString = await readJsonFile(fileName);
    List<dynamic> jsonData = json.decode(jsonString);

    return jsonData.map((e) => FunchCoopMenu.fromMenuJson(e)).toList();
  }

  Future<List<OriginalPrice>> getAllOriginalPriceFromFirestore() async {
    final priceRef = FirebaseFirestore.instance.collection('funch_price');
    final data = await priceRef.get();
    return data.docs.map((e) {
      final map = e.data();
      return OriginalPrice(map["large"], map["medium"], map["small"], e.id,
          (map["categories"] is List ? List<int>.from(map["categories"]) : <int>[]));
    }).toList();
  }

  Future<List<FunchOriginalMenu>> getAllOriginalMenu(Set<String> originalMenuRefs) async {
    final originalMenuRef = FirebaseFirestore.instance.collection('funch_original_menu');
    final data = await originalMenuRef.get();
    final allOriginalPrice = await getAllOriginalPriceFromFirestore();
    return data.docs.map((e) {
      final map = e.data();
      final price = allOriginalPrice
          .firstWhere((element) => element.id == (map["price"] as DocumentReference).id);
      return FunchOriginalMenu(
          e.id, map["title"], price, map["category"], [map["image"]], map["energy"]);
    }).toList();
  }

  Future<Map<DateTime, FunchDaysMenu>> getDaysMenu(WidgetRef ref) async {
    final allMenu = ref.watch(funchAllCoopMenuProvider);
    if (allMenu != null) {
      final data = await getDaysMenuFromFirestore();
      Set<String> originalMenuRefs = {};
      for (var key in data.keys) {
        originalMenuRefs
            .addAll((data[key]!["original_menu"] as List<DocumentReference>).map((e) => e.id));
      }
      final originalMenu = await getAllOriginalMenu(originalMenuRefs);
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
        print(list);
        print(originalList);
        return MapEntry(key, FunchDaysMenu(key, list, originalList));
      });
    } else {
      return {};
    }
  }

  FunchDaysMenu? get1DayMenu(DateTime dateTime, WidgetRef ref) {
    final data = ref.watch(funchDaysMenuProvider);
    print(data);
    if (data == null) return null;
    if (!data.containsKey(dateTime)) return null;
    return data[dateTime]!;
  }
}
