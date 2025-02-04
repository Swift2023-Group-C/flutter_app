import 'package:dotto/importer.dart';

enum FunchMenuType {
  set([1, 7, 8], "セット・単品", Icons.restaurant),
  donCurry([4, 5], "丼・カレー", Icons.rice_bowl),
  noodle([11], "麺", Icons.ramen_dining),
  sideDish([2, 9], "副菜", Icons.eco),
  dessert([3], "デザート", Icons.cake);

  final List<int> categories;
  final String title;
  final IconData icon;
  const FunchMenuType(this.categories, this.title, this.icon);
}
