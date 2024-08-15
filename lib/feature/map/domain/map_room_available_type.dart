import 'package:dotto/importer.dart';

enum RoomAvailableType {
  outlet(
    Icons.electrical_services,
    "コンセント",
  ),
  food(
    Icons.lunch_dining,
    "食べ物",
  ),
  drink(
    Icons.local_drink,
    "飲み物",
  );

  const RoomAvailableType(this.icon, this.title);

  final IconData icon;
  final String title;
}
