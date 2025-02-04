import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/my_page/feature/funch/controller/funch_controller.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/my_page/feature/funch/repository/funch_repository.dart';
import 'package:dotto/importer.dart';
import 'package:intl/intl.dart';

class MenuCard extends ConsumerWidget {
  final FunchMenu menu;

  const MenuCard(this.menu, {super.key});

  List<Widget> priceText() {
    List<Widget> priceText = [];
    final sizeStr = ["大", "中", "小"];
    final price = [menu.price.large, menu.price.medium, menu.price.small];

    for (int i = 0; i < price.length; i++) {
      final p = price[i];
      if (p == null) {
        continue;
      }
      if ((p.isNaN) || p <= 0) {
        continue;
      }
      if (priceText.isNotEmpty) {
        priceText.add(const SizedBox(width: 10));
      }
      priceText.add(
        Wrap(
          direction: Axis.horizontal,
          spacing: 0,
          children: [
            ClipOval(
              child: Container(
                width: 18,
                height: 18,
                color: customFunColor.shade400,
                child: Center(
                  child: Text(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    sizeStr[i],
                  ),
                ),
              ),
            ),
            Text(
              '¥$p',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
    }
    return priceText;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final energy = menu.energy;
    final borderRadius = 10.0;
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.white,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (menu.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                  child: Image.network(
                    menu.imageUrl,
                    errorBuilder: (context, error, stackTrace) {
                      // 読み込み失敗時に何もしない
                      return SizedBox.shrink();
                    },
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 24),
                    ),
                    if (energy != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${energy}kcal"),
                        ],
                      ),
                    Divider(
                      height: 6,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: priceText(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
