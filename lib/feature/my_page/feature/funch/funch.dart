import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/my_page/feature/funch/controller/funch_controller.dart';
import 'package:dotto/feature/my_page/feature/funch/repository/funch_repository.dart';
import 'package:dotto/importer.dart';
import 'package:intl/intl.dart';

class FunchScreen extends ConsumerWidget {
  const FunchScreen({super.key});

  Widget makeMenuTypeButton(String buttonTitle, Icon icon) {
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
              icon,
            ],
          ),
        ),
        Text(
          buttonTitle,
          style: TextStyle(
            fontSize: 9,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  List<Widget> menuTypeButton() {
    final allMenuTypeText = ["セット・単品", "丼・カレー", "麺", "副菜", "デザート"];
    final allMenuTypeIcon = [
      Icon(Icons.restaurant),
      Icon(Icons.rice_bowl),
      Icon(Icons.ramen_dining),
      Icon(Icons.eco),
      Icon(Icons.cake)
    ];
    List<Widget> menuTypeButtonList = [];

    for (int i = 0; i < allMenuTypeText.length; i++) {
      menuTypeButtonList.add(makeMenuTypeButton(allMenuTypeText[i], allMenuTypeIcon[i]));
    }
    return menuTypeButtonList;
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final funchDate = ref.watch(funchDateProvider);
    final dates = getDateMonth(funchDate);

    double buttonSize = 50;
    double buttonPadding = 8;
    List<String> weekString = ['月', '火', '水', '木', '金', '土', '日'];
    List<Color> weekColors = [
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.blue,
      Colors.red
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("学食"),
        centerTitle: true,
        actions: [Icon(Icons.event)],
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