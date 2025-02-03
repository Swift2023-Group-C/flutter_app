class FunchMenu {
  final int itemCode;
  final String name;
  final int price;
  final int category;
  final String? size;
  final List<String> imageUrl;
  final int energy;

  FunchMenu(
      this.itemCode, this.name, this.price, this.category, this.size, this.imageUrl, this.energy);

  factory FunchMenu.fromMenuJson(Map map) {
    final itemCode = int.parse(map["item_code"]);
    final name = map["display_name"];
    final price = map["price_kumika"];
    final category = int.parse(map["category_code"]);
    final size = map["size"];
    final imageUrl = (map["image_url"] as List).map((e) => e.toString()).toList();
    final energy = map["nutritionalvalue"]["energy"];
    return FunchMenu(itemCode, name, price, category, size, imageUrl, energy);
  }
}

class FunchOriginalMenu {
  final int id;
  final String title;
  final int category;
  final bool large;
  final bool small;
  final String image;

  FunchOriginalMenu(this.id, this.title, this.category, this.large, this.small, this.image);
}

class Prices {
  final int large;
  final int medium;
  final int small;

  Prices(this.large, this.medium, this.small);
}
