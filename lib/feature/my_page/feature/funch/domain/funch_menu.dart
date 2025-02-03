import 'package:dotto/feature/my_page/feature/funch/domain/funch_price.dart';

class FunchMenu {
  final String name;
  final Price price;
  final int category;
  final List<String> imageUrl;
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
    final price = Price.fromJson(map["price"]);
    final category = map["category"];
    final imageUrl = [map["image"] as String];
    final energy = map["energy"];
    return FunchCoopMenu(itemCode, name, price, category, imageUrl, energy);
  }
}

class FunchOriginalMenu extends FunchMenu {
  final String id;

  FunchOriginalMenu(this.id, super.name, super.price, super.category, super.imageUrl, super.energy);
}

class FunchDaysMenu {
  final DateTime date;
  final List<FunchCoopMenu> menu;
  final List<FunchOriginalMenu> originalMenu;

  FunchDaysMenu(this.date, this.menu, this.originalMenu);

  List<FunchCoopMenu> getMenuByCategory(int category) {
    return menu.where((element) => element.category == category).toList();
  }

  List<FunchOriginalMenu> getOriginalMenuByCategory(int category) {
    return originalMenu.where((element) => element.category == category).toList();
  }
}
