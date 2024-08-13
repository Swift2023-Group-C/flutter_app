import 'package:dotto/importer.dart';

enum RoomAvailableType {
  outlet(
    Icons.electrical_services,
    "コンセント",
  ),
  food(
    Icons.fastfood,
    "飲食",
  );

  const RoomAvailableType(this.icon, this.title);

  final IconData icon;
  final String title;
}
