import 'package:dotto/feature/my_page/feature/funch/domain/funch_price.dart';

class FunchMenu {
  final String name;
  final FunchPrice price;
  final int category;
  final String imageUrl;
  final int? energy;

  FunchMenu(this.name, this.price, this.category, this.imageUrl, this.energy);
}

class FunchCoopMenu extends FunchMenu {
  final int itemCode;

  FunchCoopMenu(
      this.itemCode, super.name, super.price, super.category, super.imageUrl, int super.energy);

  factory FunchCoopMenu.fromMenuJson(Map map) {
    final itemCode = map["item_code"];
    final name = map["title"];
    final price = FunchPrice.fromJson(map["price"]);
    final category = map["category"];
    final imageUrl = map["image"];
    final energy = map["energy"];
    return FunchCoopMenu(itemCode, name, price, category, imageUrl, energy);
  }
}

class FunchOriginalMenu extends FunchMenu {
  final String id;

  FunchOriginalMenu(this.id, super.name, super.price, super.category, super.imageUrl, super.energy);
}

class FunchMenuSet {
  final List<FunchCoopMenu> menu;
  final List<FunchOriginalMenu> originalMenu;

  FunchMenuSet(this.menu, this.originalMenu);

  List<FunchCoopMenu> getMenuByCategory(int category) {
    return menu.where((element) => element.category == category).toList();
  }

  List<FunchCoopMenu> getMenuByCategories(List<int> categories) {
    return menu.where((element) => categories.contains(element.category)).toList();
  }

  List<FunchOriginalMenu> getOriginalMenuByCategory(int category) {
    return originalMenu.where((element) => element.category == category).toList();
  }

  List<FunchOriginalMenu> getOriginalMenuByCategories(List<int> categories) {
    return originalMenu.where((element) => categories.contains(element.category)).toList();
  }
}

class FunchDaysMenu extends FunchMenuSet {
  final DateTime date;

  FunchDaysMenu(this.date, super.menu, super.originalMenu);
}

class FunchMonthMenu extends FunchMenuSet {
  final int month;

  FunchMonthMenu(this.month, super.menu, super.originalMenu);
}
