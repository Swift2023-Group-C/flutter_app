import 'package:dotto/components/app_color.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/my_page/feature/funch/widget/funch_price_list.dart';
import 'package:dotto/importer.dart';

class MenuCard extends ConsumerWidget {
  final FunchMenu menu;

  const MenuCard(this.menu, {super.key});

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
        width: MediaQuery.of(context).size.width * 0.85,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                child: menu.imageUrl.isNotEmpty
                    ? Image.network(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        menu.imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset("assets/images/no_image.png");
                        },
                      )
                    : Image.asset(
                        fit: BoxFit.cover,
                        "assets/images/no_image.png",
                        width: double.infinity,
                      ),
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
                    color: AppColor.dividerGrey,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FunchPriceList(menu),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
