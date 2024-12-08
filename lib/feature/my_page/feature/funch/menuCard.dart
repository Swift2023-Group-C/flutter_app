import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/my_page/feature/funch/controller/funch_controller.dart';
import 'package:dotto/feature/my_page/feature/funch/repository/funch_repository.dart';
import 'package:dotto/importer.dart';
import 'package:intl/intl.dart';

class MenuCard extends ConsumerWidget {
  final int itemCode;
  final String name;
  final int price;
  final int category;
  final String? size;
  final List<String> imageUrl;

  MenuCard(this.itemCode, this.name, this.price, this.category, this.size, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Image.network(.imageUrl[0]),
            ),
          ],
        ),
      ),
    );
  }
}
