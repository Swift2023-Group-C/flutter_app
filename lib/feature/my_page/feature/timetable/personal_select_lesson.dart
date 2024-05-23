import 'package:dotto/importer.dart';
import 'package:dotto/components/color_fun.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/my_page/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/feature/my_page/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/my_page/feature/timetable/widget/timetable_is_over_selected_snack_bar.dart';
import 'package:dotto/repository/narrowed_lessons.dart';

class PersonalSelectLessonScreen extends StatelessWidget {
  const PersonalSelectLessonScreen(this.term, this.week, this.period,
      {super.key});

  final int term, week, period;

  @override
  Widget build(BuildContext context) {
    final weekString = ['月', '火', '水', '木', '金'];
    final termString = {10: '前期', 20: '後期'};

    return Scaffold(
      appBar: AppBar(
        title: Text('${termString[term]} ${weekString[week - 1]}曜$period限'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final personalLessonIdList = ref.watch(personalLessonIdListProvider);
          final weekPeriodAllRecords = ref.watch(weekPeriodAllRecordsProvider);
          return weekPeriodAllRecords.when(
            data: (data) {
              List<Map<String, dynamic>> termList = data.where((record) {
                return record['week'] == week &&
                    record['period'] == period &&
                    (record['開講時期'] == term || record['開講時期'] == 0);
              }).toList();
              if (termList.isNotEmpty) {
                return ListView.builder(
                    itemCount: termList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(termList[index]['授業名']),
                        trailing: personalLessonIdList
                                .contains(termList[index]['lessonId'])
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                                onPressed: () async {
                                  //print(termList[index]['lessonId']);
                                  personalLessonIdList.removeWhere((item) =>
                                      item == termList[index]['lessonId']);
                                  await savePersonalTimeTableList(
                                      personalLessonIdList, ref);
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text("削除する"))
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customFunColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                                onPressed: () async {
                                  if (await TimetableRepository().isOverSeleted(
                                      termList[index]['lessonId'], ref)) {
                                    if (context.mounted) {
                                      timetableIsOverSelectedSnackBar(context);
                                    }
                                  } else {
                                    final lessonId =
                                        termList[index]['lessonId'];
                                    if (lessonId != null) {
                                      savePersonalTimeTableList(
                                          [...personalLessonIdList, lessonId],
                                          ref);
                                    } else {
                                      // LessonIdがnullの場合の処理（エラーメッセージの表示など）
                                    }
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                  //}
                                },
                                child: const Text("追加する")),
                      );
                    });
              } else {
                return const Center(
                  child: Text('対象の科目はありません'),
                );
              }
            },
            error: (error, stackTrace) => const Center(
              child: Text('データを取得できませんでした。'),
            ),
            loading: () => Center(child: createProgressIndicator()),
          );
        },
      ),
    );
  }
}
