import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotto/components/app_color.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/my_page/feature/funch/controller/funch_controller.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/my_page/feature/funch/repository/funch_repository.dart';
import 'package:dotto/feature/my_page/feature/funch/widget/funch_price_list.dart';
import 'package:dotto/importer.dart';
import 'package:intl/intl.dart';

class MyPageFunch extends ConsumerWidget {
  const MyPageFunch({super.key});

  Future<List<FunchCoopMenu>> _getDaysMenu(WidgetRef ref, DateTime date) async {
    final funchDaysMenu = await ref.watch(funchDaysMenuProvider);
    return funchDaysMenu[date]?.menu ?? [];
  }

  ImageProvider<Object> _getBackgroundImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return NetworkImage(
        imageUrl,
      );
    } else {
      return const AssetImage('assets/images/no_image.png');
    }
  }

  String _getDayString(DateTime date) {
    final today = DateTime.now();
    if (today.day == date.day) {
      return "今日";
    } else if (today.day + 1 == date.day) {
      return "明日";
    }
    final formatter = DateFormat('MM月dd日');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderRadius = 10.0;
    final nextDay = FunchRepository().nextDay();
    final dayString = _getDayString(nextDay);
    return FutureBuilder(
      future: _getDaysMenu(ref, nextDay),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: createProgressIndicator());
        }
        final menu = snapshot.data as List<FunchCoopMenu>;
        if (menu.isEmpty) {
          return Center(
            child: Card(
              color: AppColor.textWhite,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$dayStringの学食",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text("$dayStringの学食情報はありません"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return CarouselSlider(
          items: menu.map((e) {
            return Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.075),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 1,
                    offset: const Offset(0, 1.5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "$dayStringの学食",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: Image(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      image: _getBackgroundImage(e.imageUrl),
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/no_image.png');
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Divider(
                          height: 2,
                          color: AppColor.dividerGrey,
                        ),
                        SizedBox(height: 5),
                        FunchPriceList(e, isHome: true),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          options: CarouselOptions(
            aspectRatio: 4 / 3,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            viewportFraction: 1,
          ),
        );
      },
    );
  }
}
