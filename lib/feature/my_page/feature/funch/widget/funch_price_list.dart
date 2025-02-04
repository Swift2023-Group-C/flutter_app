import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu_type.dart';
import 'package:dotto/importer.dart';

class FunchPriceList extends StatelessWidget {
  final FunchMenu menu;
  final bool isHome;

  const FunchPriceList(this.menu, {super.key, this.isHome = false});

  List<Widget> priceText() {
    List<Widget> priceText = [];
    if (![...FunchMenuType.donCurry.categories, ...FunchMenuType.noodle.categories]
        .contains(menu.category)) {
      return [
        Text(
          '¥${menu.price.medium}',
          style: const TextStyle(fontSize: 20),
        )
      ];
    }
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
                width: isHome ? 14 : 18,
                height: isHome ? 14 : 18,
                color: customFunColor.shade400,
                child: Center(
                  child: Text(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isHome ? 8 : 10,
                    ),
                    sizeStr[i],
                  ),
                ),
              ),
            ),
            Text(
              '¥$p',
              style: TextStyle(fontSize: isHome ? 16 : 20),
            ),
          ],
        ),
      );
    }
    return priceText;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: priceText(),
    );
  }
}
