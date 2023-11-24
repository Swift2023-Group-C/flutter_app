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

    // String whereClause = personalTimeTableList.map((id) => '?').join(', ');
    // List<Map<String, dynamic>> records = await database.query(
    //   'week_period',
    //   where: 'lessonID IN ($whereClause)',
    //   whereArgs: personalTimeTableList,
    // );
    List<Map<String, dynamic>> records =
        await database.rawQuery('SELECT * FROM week_period');
    return records;
  }

  /*Widget seasonTimeTableList(   ListView表示のやつ
      int seasonnumber, List<Map<String, dynamic>> records) {
    List<Map<String, dynamic>> seasonList = records.where((record) {
      return record['開講時期'] == seasonnumber || record['開講時期'] == 0;
    }).toList();
    return ListView.builder(
      itemCount: seasonList.length,
      itemBuilder: (context, index) {
        var record = seasonList[index];
        return ListTile(
          title: Text(record['授業名'] ?? '不明な授業'),
          /* よくわからなくなったので保留
          leading: IconButton(
              onPressed: () async {
                setState(() {
                  personalTimeTableList
                      .removeWhere((item) => item == record['LessonId']);
                });
                await savePersonalTimeTableList();
                var updatedRecords = await fetchRecords();
                setState(() {
                  records = updatedRecords;
                });
                print(personalTimeTableList);
              },
              icon: const Icon(Icons.playlist_remove)),*/
        );
      },
    );
  }*/

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

  Widget tableText(
      String name, int week, period, term, List<Map<String, dynamic>> records,
      {bool exist = false}) {
    return InkWell(
        child: Container(
          margin: const EdgeInsets.all(2),
          height: 100,
          decoration: BoxDecoration(
            border: exist ? Border.all(color: Colors.grey) : null,
            color: exist ? Colors.grey.shade300 : Colors.grey.shade100,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          padding: const EdgeInsets.all(3),
          child: Text(
            exist ? name : "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PersonalSelectLessonScreen(term, week, period, records),
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
        title: const Text('時間割'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                onPressed: () {
                  seasonTimeTable(context, ref, records);
                  //print(records);
                },
                icon: const Icon(Icons.abc),
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
