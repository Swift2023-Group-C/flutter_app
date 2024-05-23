import 'package:dotto/importer.dart';
import 'package:dotto/components/animation.dart';
import 'package:dotto/components/color_fun.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/my_page/feature/timetable/personal_select_lesson.dart';
import 'package:dotto/feature/my_page/feature/timetable/controller/timetable_controller.dart';

class PersonalTimeTableScreen extends ConsumerStatefulWidget {
  const PersonalTimeTableScreen({super.key});

  @override
  ConsumerState<PersonalTimeTableScreen> createState() =>
      _PersonalTimeTableScreenState();
}

class _PersonalTimeTableScreenState
    extends ConsumerState<PersonalTimeTableScreen> {
  PageController _pageController = PageController();
  int _currentPageIndex = 0;

  Future<void> seasonTimeTable(BuildContext context) async {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);
    final weekPeriodAllRecords = ref.watch(weekPeriodAllRecordsProvider);
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("取得してる科目一覧"),
            content: SizedBox(
              width: double.maxFinite,
              child: weekPeriodAllRecords.when(
                data: (data) {
                  List<Map<String, dynamic>> seasonList = data.where((record) {
                    return personalLessonIdList.contains(record['lessonId']);
                  }).toList();
                  return ListView.builder(
                    itemCount: seasonList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(seasonList[index]['授業名']),
                      );
                    },
                  );
                },
                error: (error, stackTrace) => const Center(
                  child: Text('データを取得できませんでした'),
                ),
                loading: () => Center(
                  child: createProgressIndicator(),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget tableText(
    String name,
    int week,
    period,
    term,
    List<Map<String, dynamic>> records,
  ) {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);
    List<Map<String, dynamic>> selectedLessonList = records.where((record) {
      return record['week'] == week &&
          record['period'] == period &&
          (record['開講時期'] == term || record['開講時期'] == 0) &&
          personalLessonIdList.contains(record['lessonId']);
    }).toList();
    return InkWell(
      // 表示
      child: Container(
        margin: const EdgeInsets.all(2),
        height: 100,
        child: selectedLessonList.isNotEmpty
            ? Column(
                children: selectedLessonList
                    .map(
                      (lesson) => Expanded(
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
                        ),
                      ),
                    )
                    .toList(),
              )
            // Text(
            //   textAlign: TextAlign.center,
            //   style: const TextStyle(fontSize: 10),
            // );
            : Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                padding: const EdgeInsets.all(2),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
      ),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PersonalSelectLessonScreen(term, week, period),
              transitionsBuilder: fromRightAnimation),
        );
      },
    );
  }

  Widget seasonTimeTableList(int seasonnumber, WidgetRef ref) {
    final weekPeriodAllRecords = ref.watch(weekPeriodAllRecordsProvider);
    final weekString = ['月', '火', '水', '木', '金'];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: weekPeriodAllRecords.when(
          data: (data) => Table(
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
                        "${weekString[j - 1]}曜$i限", j, i, seasonnumber, data),
                  }
                ])
              }
            ],
          ),
          error: (error, stackTrace) => const Center(
            child: Text("データを取得できませんでした。"),
          ),
          loading: () => Center(
            child: createProgressIndicator(),
          ),
        ),
      ),
    );
  }

  void initShowPage() {
    DateTime now = DateTime.now();
    if ((now.month >= 9) || (now.month <= 2)) {
      _pageController = PageController(initialPage: 1);
      _currentPageIndex = 1;
    }
  }

  @override
  void initState() {
    super.initState();
    initShowPage();
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
                  seasonTimeTable(context);
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
                seasonTimeTableList(10, ref),
                seasonTimeTableList(20, ref),
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
