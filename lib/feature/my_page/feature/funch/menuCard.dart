import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/my_page/feature/funch/controller/funch_controller.dart';
import 'package:dotto/feature/my_page/feature/funch/repository/funch_repository.dart';
import 'package:dotto/importer.dart';
import 'package:intl/intl.dart';

class MenuCard extends ConsumerWidget {
  final int itemCode;
  final String name;
  final List<int> price;
  final List<int?> calory;
  final int category;
  final String? size;
  final List<String> imageUrl;

  MenuCard(
      this.itemCode, this.name, this.price, this.calory, this.category, this.size, this.imageUrl);

  List<Widget> priceText() {
    List<Widget> priceText = [];
    final sizeStr = ["大", "中", "小"];

    for (int i = 0; i < price.length; i++) {
      if (!(price[i].isNaN) && price[i] > 0) {
        priceText.add(
          ClipOval(
            child: Container(
              width: 20,
              height: 20,
              color: customFunColor,
              child: Center(
                child: Text(
                  style: const TextStyle(color: Colors.white),
                  sizeStr[i],
                ),
              ),
            ),
          ),
        );
        priceText.add(
          Text(
            '¥${price[i]}',
            style: const TextStyle(fontSize: 30),
          ),
        );
      }
    }
    return priceText;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.white,
        shadowColor: Colors.black,
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl[0].isNotEmpty)
                Image.network(
                  imageUrl[0],
                  errorBuilder: (context, error, stackTrace) {
                    // 読み込み失敗時に何もしない
                    return SizedBox.shrink();
                  },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Text(
                      //   BusRepository().formatDuration(beginTime),
                      //   style: const TextStyle(fontSize: 40),
                      // ),
                      // Transform.translate(
                      //   offset: const Offset(0, -5),
                      //   child: Text(isKameda && busIsTo ? '亀田支所発' : '発'),
                      // ),
                      const Spacer(),
                      // Transform.translate(
                      Text(
                        "${(calory[1] ?? 0) > 0 ? calory[1] : calory[0]}kcal",
                        style: const TextStyle(fontSize: 20),
                        // '${BusRepository().formatDuration(endTime)}${isKameda && !busIsTo ? '亀田支所着' : '着'}'
                      ),
                      // )
                    ],
                  ),
                  Divider(
                    height: 6,
                    color: Colors.black,
                  ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...priceText(),
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
