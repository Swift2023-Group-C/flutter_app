import 'package:dotto/importer.dart';
import 'package:dotto/components/animation.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/kamoku_detail/kamoku_detail_page_view.dart';
import 'package:dotto/feature/kamoku_search/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/kamoku_search/repository/kamoku_search_repository.dart';
import 'package:dotto/feature/my_page/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/feature/my_page/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/my_page/feature/timetable/widget/timetable_is_over_selected_snack_bar.dart';

class KamokuSearchResults extends ConsumerWidget {
  final List<Map<String, dynamic>> records;

  const KamokuSearchResults({super.key, required this.records});

  Future<Map<int, String>> getWeekPeriod(List<int> lessonIdList) async {
    List<Map<String, dynamic>> records =
        await KamokuSearchRepository().fetchWeekPeriodDB(lessonIdList);
    Map<int, Map<int, List<int>>> weekPeriodMap = {};
    for (var record in records) {
      final int lessonId = record['lessonId'];
      final int week = record['week'];
      final int period = record['period'];
      if (weekPeriodMap.containsKey(lessonId)) {
        if (weekPeriodMap[lessonId]!.containsKey(week)) {
          weekPeriodMap[lessonId]![week]!.add(period);
        } else {
          weekPeriodMap[lessonId]![week] = [period];
        }
      } else {
        weekPeriodMap[lessonId] = {
          week: [period]
        };
      }
    }
    Map<int, String> weekPeriodStringMap = weekPeriodMap.map((lessonId, value) {
      List<String> weekString = ['', '月', '火', '水', '木', '金', '土', '日'];
      List<String> s = [];
      value.forEach(
        (week, periodList) {
          if (week != 0) {
            s.add('${weekString[week]}${periodList.join()}');
          }
        },
      );
      return MapEntry(lessonId, s.join(','));
    });
    return weekPeriodStringMap;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);
    final kamokuSearchController = ref.read(kamokuSearchControllerProvider);
    final twoWeekTimeTableDataNotifier = ref.read(twoWeekTimeTableDataProvider.notifier);
    //loadPersonalTimeTableList();
    return FutureBuilder(
      future: getWeekPeriod(records.map((e) => e['LessonId'] as int).toList()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<int, String> weekPeriodStringMap = snapshot.data!;
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final int lessonId = record['LessonId'];
              return ListTile(
                title: Text(record['授業名'] ?? ''),
                subtitle: Text(weekPeriodStringMap[lessonId] ?? ''),
                onTap: () async {
                  await Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return KamokuDetailPageScreen(
                          lessonId: lessonId,
                          lessonName: record['授業名'],
                          kakomonLessonId: record['過去問'],
                        );
                      },
                      transitionsBuilder: fromRightAnimation,
                    ),
                  );
                  kamokuSearchController.searchBoxFocusNode.unfocus();
                },
                trailing: const Icon(Icons.chevron_right),
                leading: IconButton(
                  icon: Icon(Icons.playlist_add,
                      color: personalLessonIdList.contains(lessonId) ? Colors.green : Colors.black),
                  onPressed: () async {
                    if (!personalLessonIdList.contains(lessonId)) {
                      if (await TimetableRepository().isOverSeleted(lessonId, ref)) {
                        if (context.mounted) {
                          timetableIsOverSelectedSnackBar(context);
                        }
                      } else {
                        TimetableRepository().addPersonalTimeTableList(lessonId, ref);
                      }
                    } else {
                      TimetableRepository().removePersonalTimeTableList(lessonId, ref);
                    }
                    twoWeekTimeTableDataNotifier.state =
                        await TimetableRepository().get2WeekLessonSchedule(ref);
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              height: 0,
            ),
          );
        } else {
          return Center(
            child: createProgressIndicator(),
          );
        }
      },
    );
  }
}
