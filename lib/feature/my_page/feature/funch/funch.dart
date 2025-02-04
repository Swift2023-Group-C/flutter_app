import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/my_page/feature/funch/controller/funch_controller.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu_type.dart';
import 'package:dotto/feature/my_page/feature/funch/widget/funch_menu_card.dart';
import 'package:dotto/importer.dart';
import 'package:intl/intl.dart';

class FunchScreen extends ConsumerWidget {
  const FunchScreen({super.key});

  Widget makeMenuTypeButton(FunchMenuType menuType, WidgetRef ref) {
    double buttonSize = 50;
    final funchMenuType = ref.watch(funchMenuTypeProvider);
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(funchMenuTypeProvider.notifier).set(menuType);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: funchMenuType == menuType ? customFunColor : Colors.white,
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
              Icon(
                menuType.icon,
                color: funchMenuType == menuType ? Colors.white : customFunColor,
              ),
            ],
          ),
        ),
        Text(
          menuType.title,
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  List<Widget> menuTypeButton(WidgetRef ref) {
    return FunchMenuType.values.map((e) => makeMenuTypeButton(e, ref)).toList();
  }

  Future<List<DateTime>> getMenuDates(WidgetRef ref) async {
    final funchDate = await ref.watch(funchDaysMenuProvider);
    return funchDate.keys.toList();
  }

  Future<List<Map>> _getMenu(WidgetRef ref) async {
    return [await ref.watch(funchDaysMenuProvider), await ref.watch(funchMonthMenuProvider)];
  }

  void _showModalBottomSheet(BuildContext context, WidgetRef ref) async {
    final dates = await getMenuDates(ref);
    List<String> weekString = ['月', '火', '水', '木', '金', '土', '日'];
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
                    ref.read(funchDateProvider.notifier).set(toElement);
                    Navigator.pop(context);
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
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final funchDate = ref.watch(funchDateProvider);
    final nowMenuType = ref.watch(funchMenuTypeProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.expand_more,
                color: Colors.white,
                size: 30,
              ), // アイコンの配置
              SizedBox(width: 8),
              Text(
                DateFormat('MM月dd日の学食').format(funchDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          onPressed: () async {
            if (context.mounted) {
              _showModalBottomSheet(context, ref);
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
                children: menuTypeButton(ref),
              ),
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

                  final dayMenu = funchDaysMenu[funchDate];
                  final monthMenu = funchMonthMenu[funchDate.month];
                  if (dayMenu == null || monthMenu == null) return Text("この日の学食はありません。");
                  final funchCategorizedMenu = [
                    ...dayMenu.getMenuByCategories(nowMenuType.categories),
                    ...dayMenu.getOriginalMenuByCategories(nowMenuType.categories),
                    ...monthMenu.getMenuByCategories(nowMenuType.categories),
                    ...monthMenu.getOriginalMenuByCategories(nowMenuType.categories),
                  ];

                  if (funchCategorizedMenu.isEmpty) return Text("このカテゴリーの学食はありません。");

                  return Column(
                    children: funchCategorizedMenu.map((menu) {
                      return MenuCard(menu);
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
