import 'package:flutter/material.dart';
import 'package:flutter_app/components/db_config.dart';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_app/screens/personal_select_lesson.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/repository/narrowed_lessons.dart';
import 'package:sqflite/sqflite.dart';

class PersonalTimeTableScreen extends ConsumerStatefulWidget {
  const PersonalTimeTableScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PersonalTimeTableScreen> createState() =>
      _PersonalTimeTableScreenState();
}

class _PersonalTimeTableScreenState
    extends ConsumerState<PersonalTimeTableScreen> {
  late List<Map<String, dynamic>> records = [];
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  Future<List<Map<String, dynamic>>> fetchRecords() async {
    Database database = await openDatabase(SyllabusDBConfig.dbPath);

    List<Map<String, dynamic>> records =
        await database.rawQuery('SELECT * FROM week_period');
    return records;
  }

  Future<void> seasonTimeTable(BuildContext context, WidgetRef ref,
      List<Map<String, dynamic>> records) async {
    final personalLessonIdList = await loadPersonalTimeTableList(ref);
    List<Map<String, dynamic>> seasonList = records.where((record) {
      return personalLessonIdList.contains(record['lessonId']);
    }).toList();
    if (context.mounted) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("取得してる科目一覧"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: personalLessonIdList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(seasonList[index]['授業名']),
                    );
                  },
                ),
              ),
            );
          });
    }
  }

  Widget animation(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const Offset begin = Offset(1.0, 0.0); // 開始位置（画面外から）
    const Offset end = Offset.zero; // 終了位置（画面内へ）
    final Animatable<Offset> tween = Tween(begin: begin, end: end)
        .chain(CurveTween(curve: Curves.easeInOut));
    final Animation<Offset> offsetAnimation = animation.drive(tween);

    // お洒落なアニメーションの追加例
    return FadeTransition(
      // フェードインしながらスライド
      opacity: animation, // フェード用のアニメーション
      child: SlideTransition(
        // スライド
        position: offsetAnimation, // スライド用のアニメーション
        child: child, // 子ウィジェット
      ),
    );
  }

  //SnackBarを表示するための関数
  Future<void> overSelectLessonSnackbar(
      List<Map<String, dynamic>> selectedLessonList) async {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);
    selectedLessonList.removeLast();
    personalLessonIdList.removeLast();
    await savePersonalTimeTableList(personalLessonIdList, ref);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('１つのコマに３つ以上選択できません')),
    );
  }

  Widget tableText(
      String name, int week, period, term, List<Map<String, dynamic>> records,
      {bool exist = false}) {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);
    List<Map<String, dynamic>> selectedLessonList = records.where((record) {
      return record['week'] == week &&
          record['period'] == period &&
          (record['開講時期'] == term || record['開講時期'] == 0) &&
          personalLessonIdList.contains(record['lessonId']);
    }).toList();
    if (selectedLessonList.length > 2) {
      overSelectLessonSnackbar(selectedLessonList);
    }
    return InkWell(
        // 表示
        child: Container(
          margin: const EdgeInsets.all(2),
          height: 100,
          child: selectedLessonList.isNotEmpty
              ? Column(
                  children: selectedLessonList
                      .map((lesson) => Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.grey.shade300,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              lesson['授業名'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 8),
                            ),
                          )))
                      .toList(),
                )
              // Text(
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(fontSize: 10),
              // );
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Center(
                      child: Icon(
                    Icons.add,
                    color: Colors.grey.shade400,
                  )),
                ),
        ),
        onTap: () {
          debugPrint(personalLessonIdList.toString());
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PersonalSelectLessonScreen(
                        term, week, period, records, selectedLessonList),
                transitionsBuilder: animation),
          );
        });
  }

  Widget seasonTimeTableList(
      int seasonnumber, List<Map<String, dynamic>> records) {
    final weekString = ['月', '火', '水', '木', '金'];
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
          5: FlexColumnWidth(1),
          6: FlexColumnWidth(1),
        },
        children: <TableRow>[
          TableRow(
            children: weekString
                .map((e) => TableCell(
                        child: Center(
                            child: Text(
                      e,
                      style: const TextStyle(fontSize: 10),
                    ))))
                .toList(),
          ),
          for (int i = 1; i <= 6; i++) ...{
            TableRow(children: [
              for (int j = 1; j <= 5; j++) ...{
                tableText(
                    "${weekString[j - 1]}曜$i限", j, i, seasonnumber, records),
              }
            ])
          }
        ],
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    fetchRecords().then((value) {
      setState(() {
        records = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('時間割 設定'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                onPressed: () {
                  seasonTimeTable(context, ref, records);
                  //print(records);
                },
                icon: const Icon(Icons.list),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: deviceHeight * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                2,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: Container(
                    width: deviceWidth * 0.3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: index == _currentPageIndex
                              ? customFunColor.shade400
                              : Colors.transparent, // 非選択時は透明
                          width: deviceWidth * 0.005,
                        ),
                      ),
                    ),
                    child: Text(
                      _getPageName(index),
                      style: TextStyle(
                        fontSize: deviceWidth / 25,
                        fontWeight: FontWeight.bold,
                        color: index == _currentPageIndex
                            ? customFunColor.shade400
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                seasonTimeTableList(10, records),
                seasonTimeTableList(20, records),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageName(int index) {
    switch (index) {
      case 0:
        return '前期';
      case 1:
        return '後期';
      default:
        return '';
    }
  }
}
