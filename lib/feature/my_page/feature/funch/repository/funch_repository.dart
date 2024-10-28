import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';

class FunchRepository {
  static final FunchRepository _instance = FunchRepository._internal();
  factory FunchRepository() {
    return _instance;
  }
  FunchRepository._internal();

  List<FunchMenu> get1DayMenu(DateTime dateTime) {
    List<FunchMenu> list = [
      FunchMenu("3377", "スンドゥブ", 385, "https://chuboz.jp/items/images/3377.png"),
      FunchMenu("3304", "ロースカツ卵あんかけ", 363, "https://chuboz.jp/items/images/3304.png"),
    ];
    return list;
  }
}
