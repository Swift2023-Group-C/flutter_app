class Price {
  final int? large;
  final int medium;
  final int? small;

  Price(this.large, this.medium, this.small);

  factory Price.fromJson(Map map) {
    final large = map["large"];
    final medium = map["medium"];
    final small = map["small"];
    return Price(large, medium, small);
  }
}

class OriginalPrice extends Price {
  final String id;
  final List<int> categories;

  OriginalPrice(super.large, super.medium, super.small, this.id, this.categories);

  factory OriginalPrice.fromJson(Map map) {
    final large = map["large"];
    final medium = map["medium"];
    final small = map["small"];
    final id = map["id"];
    final categories = (map["categories"] as List).map((e) => e as int).toList();
    return OriginalPrice(large, medium, small, id, categories);
  }
}

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
}
