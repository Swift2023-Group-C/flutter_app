import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/my_page/feature/funch/controller/funch_controller.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu_type.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_price.dart';
import 'package:dotto/feature/my_page/feature/funch/repository/funch_repository.dart';
import 'package:dotto/feature/my_page/feature/funch/menu_card.dart';
import 'package:dotto/importer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

class FunchScreen extends ConsumerWidget {
  const FunchScreen({super.key});

  Widget makeMenuTypeButton(FunchMenuType menuType) {
    double buttonSize = 50;
    double buttonPadding = 8;
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            //ref.read(funchDateProvider.notifier).set(date);
          },
          style: ElevatedButton.styleFrom(
            surfaceTintColor: Colors.white,
            shape: const CircleBorder(
              side: BorderSide(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            minimumSize: Size(buttonSize, buttonSize),
            fixedSize: Size(buttonSize, buttonSize),
            padding: const EdgeInsets.all(0),
          ),
          // アイコンの配置
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(menuType.icon),
            ],
          ),
        ),
        Text(
          menuType.name,
          style: TextStyle(
            fontSize: 9,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  List<Widget> menuTypeButton() {
    return FunchMenuType.values.map((e) => makeMenuTypeButton(e)).toList();
  }

  //指定した月の曜日を返す
  List<DateTime> getDateMonth(DateTime selectedDate) {
    DateTime startDate = DateTime(selectedDate.year, selectedDate.month, 1);

    // if (selectedDate < now.month) {
    //   startDate = DateTime(now.year + 1, selectedDate, 1); //過去の月は来年にする
    // }
    List<DateTime> dates = [];
    final nextMonthFirst = DateTime(startDate.year, startDate.month + 1, 1);
    final monthDays = nextMonthFirst.subtract(const Duration(days: 1)).day;

    for (int i = 0; i < monthDays; i++) {
      final date = startDate.add(Duration(days: i));
      if (date.weekday < 6) dates.add(date); //土日は除外
    }
    return dates;
  }

  Future<List<DateTime>> getMenuDates(WidgetRef ref) async {
    final funchDate = await ref.watch(funchDaysMenuProvider);
    return funchDate.keys.toList();
  }

  Future<List<Map>> _getMenu(WidgetRef ref) async {
    return [await ref.watch(funchDaysMenuProvider), await ref.watch(funchMonthMenuProvider)];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final funchDate = ref.watch(funchDateProvider);

    double buttonSize = 50;
    double buttonPadding = 8;
    List<String> weekString = ['月', '火', '水', '木', '金', '土', '日'];

    return Scaffold(
      appBar: AppBar(
        // title: const Text("学食"),
        centerTitle: true,

        title: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.expand_more, color: Colors.white, size: 20), // アイコンの配置
              Text(
                DateFormat('MM月dd日の学食').format(funchDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          ),
          onPressed: () async {
            final dates = await getMenuDates(ref);
            if (context.mounted) {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dates.map((toElement) {
                          return ElevatedButton(
                            onPressed: () {
                              // ref.read(funchDateProvider.notifier).set(toElement);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('MM月dd日 ${weekString[toElement.weekday - 1]}曜日')
                                      .format(toElement),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  });
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 均等配置
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 均等配置
                children: menuTypeButton(),
              ),
            ),

            MenuCard(
              FunchCoopMenu(10002, "チキン竜田丼", FunchPrice(616, 528, 462), 4,
                  "https://chuboz.jp/items/images/10002.png", 845),
            ),

            FutureBuilder(
                future: _getMenu(ref),
                builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final Map<DateTime, FunchDaysMenu> funchDaysMenu = snapshot.data![0];
                    final Map<int, FunchMonthMenu> funchMonthMenu = snapshot.data![1];
                    return Column(
                      children: funchDaysMenu.keys.map((date) {
                        final dayMenu = funchDaysMenu[date];
                        if (dayMenu == null) return const SizedBox.shrink();
                        return Column(
                          children: [
                            ...dayMenu.menu.map((menu) {
                              return MenuCard(menu);
                            }),
                            ...dayMenu.originalMenu.map((menu) {
                              return MenuCard(menu);
                            })
                          ],
                        );
                      }).toList(),
                    );
                  }
                })
          ],
        ),

        /* dates.map((date) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: buttonPadding / 2),
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(funchDateProvider.notifier).set(date);
                      },
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.white,
                        backgroundColor: funchDate == date ? customFunColor : Colors.white,
                        foregroundColor: funchDate == date ? Colors.white : Colors.black,
                        shape: const CircleBorder(
                          side: BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        minimumSize: Size(buttonSize, buttonSize),
                        fixedSize: Size(buttonSize, buttonSize),
                        padding: const EdgeInsets.all(0),
                      ),
                      // 日付表示
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('dd').format(date),
                            style: TextStyle(
                              fontWeight: (funchDate == date) ? FontWeight.bold : null,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            weekString[date.weekday - 1],
                            style: TextStyle(
                              fontSize: 9,
                              color:
                                  funchDate == date ? Colors.white : weekColors[date.weekday - 1],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),*/
        //),
      ),
      /* // 月選択 プルダウン
            DropdownButton<int>(
              value: funchDate.month,
              onChanged: (int? value) {
                if (value != null) {
                  final nextMonthDate = DateTime(funchDate.year, value, 1);
                  ref.read(funchDateProvider.notifier).set(nextMonthDate);
                }
              },
              items: <int>[for (int i = 1; i <= 12; i++) i].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text("$value月"),
                );
              }).toList(),
            ),
            // 日付選択 スクロール
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: dates.map((date) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: buttonPadding / 2),
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(funchDateProvider.notifier).set(date);
                      },
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.white,
                        backgroundColor: funchDate == date ? customFunColor : Colors.white,
                        foregroundColor: funchDate == date ? Colors.white : Colors.black,
                        shape: const CircleBorder(
                          side: BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        minimumSize: Size(buttonSize, buttonSize),
                        fixedSize: Size(buttonSize, buttonSize),
                        padding: const EdgeInsets.all(0),
                      ),
                      // 日付表示
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('dd').format(date),
                            style: TextStyle(
                              fontWeight: (funchDate == date) ? FontWeight.bold : null,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            weekString[date.weekday - 1],
                            style: TextStyle(
                              fontSize: 9,
                              color:
                                  funchDate == date ? Colors.white : weekColors[date.weekday - 1],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),*/
      //Text(funchDate.toString()),
      // List<日替わりメニュー> 写真 メニュー名 値段（大中小）

      /*
            Column(
              children: FunchRepository().get1DayMenu(funchDate, ref).map((menu) {
                return Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Image.network(menu.imageUrl[0]),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(menu.name),
                        Text("${menu.price}円"),
                      ],
                    ),
                    const Icon(Icons.chevron_right_sharp),
                  ],
                );
              }).toList(),
            )
            // List<常設メニュー> 未実装
          ],
        ),
      ),*/
    );
  }
}

// 月選択 プルダウン
// 日付選択 スクロール 時間割と似たような
// (日付)
// List<日替わりメニュー> 写真 メニュー名 値段（大中小）
// List<常設メニュー>
// メニュー押したら詳細画面に飛ぶ
