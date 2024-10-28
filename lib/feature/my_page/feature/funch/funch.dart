import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/my_page/feature/funch/controller/funch_controller.dart';
import 'package:dotto/feature/my_page/feature/funch/repository/funch_repository.dart';
import 'package:dotto/importer.dart';
import 'package:intl/intl.dart';

class FunchScreen extends ConsumerWidget {
  const FunchScreen({super.key});
//今月の曜日を返す
  List<DateTime> getDateMonth() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);

    List<DateTime> dates = [];
    final nextMonthFirst = DateTime(now.year, now.month + 1, 1);
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
    List<DateTime> dates = getDateMonth();
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
        title: const Text("学食メニュー"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 月選択 プルダウン
            TextButton(
              onPressed: () {
                // 月選択 未実装
              },
              child: const Text("10月"),
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
            ),
            // List<日替わりメニュー> 写真 メニュー名 値段（大中小）
            Column(
              children: FunchRepository().get1DayMenu(DateTime.now()).map((menu) {
                return Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Image.network(menu.imageUrl),
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
      ),
    );
  }
}

// 月選択 プルダウン
// 日付選択 スクロール 時間割と似たような
// (日付)
// List<日替わりメニュー> 写真 メニュー名 値段（大中小）
// List<常設メニュー>
// メニュー押したら詳細画面に飛ぶ