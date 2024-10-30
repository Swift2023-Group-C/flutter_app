class FunchMenu {
  final int itemCode;
  final String name;
  final int price;
  final int category;
  final String? size;
  final String imageUrl;

  FunchMenu(this.itemCode, this.name, this.price, this.category, this.size, this.imageUrl);

  factory FunchMenu.fromMenuJson(Map map) {
    final itemCode = int.parse(map["item_code"]);
    final name = map["display_name"];
    final price = map["price_kumika"];
    final category = int.parse(map["category_code"]);
    final size = map["size"];
    final imageUrl = map["image_url"];
    return FunchMenu(itemCode, name, price, category, size, imageUrl);
  }
}
