import 'package:flutter/material.dart';
import '../repository/kamoku_sort.dart';

class KamokuDetailSyllabusScreen extends StatelessWidget {
  const KamokuDetailSyllabusScreen({Key? key, required this.lessonId})
      : super(key: key);

  final int lessonId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchDetails(lessonId),
        builder: (context, snapshot) {
          Map<String, dynamic> details = snapshot.data!;
          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return ListTile(
                //title: Text('LessonId: ${details['LessonId']}'),
                title: const Text(
                  '詳細情報',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('授業名: ${details['授業名']}'),
                    Text('Course: ${details['Course']}'),
                    Text('配当年次: ${details['配当年次']}'),
                    Text('開講時期: ${details['開講時期']}'),
                    Text('単位数: ${details['単位数']}'),
                    Text('担当教員名: ${details['担当教員名']}'),
                    Text('実務家教員区分: ${details['実務家教員区分']}'),
                    Text('授業形態: ${details['授業形態']}'),
                    Text('授業の概要: ${details['授業の概要']}'),
                    Text('授業の到達目標: ${details['授業の到達目標']}'),
                    Text('提出課題等: ${details['提出課題等']}'),
                    Text('成績の評価方法・基準: ${details['成績の評価方法・基準']}'),
                    Text('テキスト: ${details['テキスト']}'),
                    Text('参考書: ${details['参考書']}'),
                    Text('履修条件: ${details['履修条件']}'),
                    Text('事前学習: ${details['事前学習']}'),
                    Text('事後学習: ${details['事後学習']}'),
                    Text('履修上の留意点: ${details['履修上の留意点']}'),
                    Text('キーワード/keyword: ${details['キーワード/keyword']}'),
                    Text('対象コース・領域: ${details['対象コース・領域']}'),
                    Text('科目群・科目区分: ${details['科目群・科目区分']}'),
                    Text('授業・試験の形式: ${details['授業・試験の形式']}'),
                    Text('教授言語: ${details['教授言語']}'),
                    Text('DSOP対象科目: ${details['DSOP対象科目']}'),
                    Text('(E)Course outline: ${details['(E)Course outline']}'),
                    Text(
                        '(E)Course Objectives: ${details['(E)Course Objectives']}'),
                    Text(
                        '(E)Course Schedule: ${details['(E)Course Schedule']}'),
                    Text(
                        '(E)Prior/Post Assignment: ${details['(E)Prior/Post Assignment']}'),
                    Text('(E)Assessment: ${details['(E)Assessment']}'),
                    Text('(E)Textbooks: ${details['(E)Textbooks']}'),
                    Text(
                        '(E)Language of Instruction: ${details['(E)Language of Instruction']}'),
                    Text('(E)Note: ${details['(E)Note']}'),
                    Text(
                        '(E)Requirements for registration: ${details['(E)Requirements for registration']}'),
                    Text(
                        '(E)Type of class and exam: ${details['(E)Type of class and exam']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
