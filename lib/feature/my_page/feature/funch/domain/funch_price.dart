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
}
