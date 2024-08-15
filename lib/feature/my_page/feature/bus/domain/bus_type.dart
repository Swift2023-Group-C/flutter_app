import 'package:dotto/components/app_color.dart';
import 'package:dotto/importer.dart';

enum BusType {
  kameda("亀田支所", Colors.grey),
  goryokaku("五稜郭方面", AppColor.dividerRed),
  syowa("昭和方面", AppColor.linkTextBlue),
  other("", Colors.grey);

  final String where;
  final Color dividerColor;
  const BusType(this.where, this.dividerColor);
}
