import 'package:flutter/material.dart';
import 'package:flutter_app/repository/narrowed_lessons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalSelectLessonScreen extends StatelessWidget {
  const PersonalSelectLessonScreen(
      this.term, this.week, this.period, this.records, this.selectedLessonList,
      {Key? key})
      : super(key: key);

  final int term, week, period;
  final List<Map<String, dynamic>> records;
  final List<Map<String, dynamic>> selectedLessonList;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> termList = records.where((record) {
      return record['week'] == week &&
          record['period'] == period &&
          record['開講時期'] == term;
    }).toList();

    return Scaffold(
      appBar: AppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final personalLessonIdList = ref.watch(personalLessonIdListProvider);
          return ListView.builder(
              itemCount: termList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    print(personalLessonIdList);
                  },
                  title: Text(termList[index]['授業名']),
                  trailing: personalLessonIdList
                          .contains(termList[index]['lessonId'])
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                          ),
                          onPressed: () async {
                            //print(termList[index]['lessonId']);
                            personalLessonIdList.removeWhere(
                                (item) => item == termList[index]['lessonId']);
                            savePersonalTimeTableList(
                                personalLessonIdList, ref);
                            Navigator.of(context).pop();
                          },
                          child: const Text("削除する"))
                      : ElevatedButton(
                          onPressed: () async {
                            var lessonId = termList[index]['lessonId'];
                            if (lessonId != null) {
                              print(lessonId);
                              personalLessonIdList.add(lessonId);
                              savePersonalTimeTableList(
                                  personalLessonIdList, ref);
                            } else {
                              // LessonIdがnullの場合の処理（エラーメッセージの表示など）
                            }
                            Navigator.of(context).pop();
                          },
                          child: const Text("追加する")),
                );
              });
        },
      ),
    );
  }
}
