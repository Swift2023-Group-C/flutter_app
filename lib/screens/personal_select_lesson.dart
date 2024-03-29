import 'package:dotto/components/color_fun.dart';
import 'package:flutter/material.dart';
import 'package:dotto/repository/narrowed_lessons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalSelectLessonScreen extends StatelessWidget {
  const PersonalSelectLessonScreen(
      this.term, this.week, this.period, this.records, this.selectedLessonList,
      {super.key});

  final int term, week, period;
  final List<Map<String, dynamic>> records;
  final List<Map<String, dynamic>> selectedLessonList;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> termList = records.where((record) {
      return record['week'] == week &&
          record['period'] == period &&
          (record['開講時期'] == term || record['開講時期'] == 0);
    }).toList();
    final weekString = ['月', '火', '水', '木', '金'];
    final termString = {10: '前期', 20: '後期'};

    return Scaffold(
      appBar: AppBar(
        title: Text('${termString[term]} ${weekString[week - 1]}曜$period限'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final personalLessonIdList = ref.watch(personalLessonIdListProvider);
          if (termList.isNotEmpty) {
            return ListView.builder(
                itemCount: termList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      debugPrint(personalLessonIdList.toString());
                    },
                    title: Text(termList[index]['授業名']),
                    trailing: personalLessonIdList
                            .contains(termList[index]['lessonId'])
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onPressed: () async {
                              //print(termList[index]['lessonId']);
                              personalLessonIdList.removeWhere((item) =>
                                  item == termList[index]['lessonId']);
                              savePersonalTimeTableList(
                                  personalLessonIdList, ref);
                              Navigator.of(context).pop();
                            },
                            child: const Text("削除する"))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customFunColor,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            onPressed: () async {
                              // if (selectedLessonList.length > 1) {
                              //   ScaffoldMessenger.of(context)
                              //       .removeCurrentSnackBar();
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //           content: Text('１つのコマに２つ以上選択できません')));
                              // } else {
                              var lessonId = termList[index]['lessonId'];
                              if (lessonId != null) {
                                debugPrint(lessonId.toString());
                                personalLessonIdList.add(lessonId);
                                savePersonalTimeTableList(
                                    personalLessonIdList, ref);
                              } else {
                                // LessonIdがnullの場合の処理（エラーメッセージの表示など）
                              }
                              Navigator.of(context).pop();
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
      ),
    );
  }
}
