import 'package:flutter/material.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/repository/kamoku_sort.dart';

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
          if (snapshot.hasData) {
            Map<String, dynamic> details = snapshot.data!;
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  // title: const Text(
                  //   '詳細情報',
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  // ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow(context, '授業名', details['授業名']),
                      _buildRow(context, 'Course', details['Course']),
                      _buildRow(context, '配当年次', details['配当年次']),
                      _buildRow(context, '開講時期', details['開講時期']),
                      _buildRow(context, '単位数', details['単位数']),
                      _buildRow(context, '担当教員名', details['担当教員名']),
                      _buildRow(context, '実務家教員区分', details['実務家教員区分']),
                      _buildRow(context, '授業形態', details['授業形態']),
                      _buildRow(context, '授業の概要', details['授業の概要']),
                      _buildRow(context, '授業の到達目標', details['授業の到達目標']),
                      _buildRow(context, '提出課題等', details['提出課題等']),
                      _buildRow(context, '成績の評価方法・基準', details['成績の評価方法・基準']),
                      _buildRow(context, 'テキスト', details['テキスト']),
                      _buildRow(context, '参考書', details['参考書']),
                      _buildRow(context, '履修条件', details['履修条件']),
                      _buildRow(context, '事前学習', details['事前学習']),
                      _buildRow(context, '事後学習', details['事後学習']),
                      _buildRow(context, '履修上の留意点', details['履修上の留意点']),
                      // _buildRow('キーワード/keyword', details['キーワード/keyword']),
                      // _buildRow('対象コース・領域', details['対象コース・領域']),
                      // _buildRow('科目群・科目区分', details['科目群・科目区分']),
                      // _buildRow('授業・試験の形式', details['授業・試験の形式']),
                      // _buildRow('教授言語', details['教授言語']),
                      // _buildRow('DSOP対象科目', details['DSOP対象科目']),
                      // _buildRow(
                      //     '(E)Course outline', details['(E)Course outline']),
                      // _buildRow('(E)Course Objectives',
                      //     details['(E)Course Objectives']),
                      // _buildRow(
                      //     '(E)Course Schedule', details['(E)Course Schedule']),
                      // _buildRow('(E)Prior/Post Assignment',
                      //     details['(E)Prior/Post Assignment']),
                      // _buildRow('(E)Assessment', details['(E)Assessment']),
                      // _buildRow('(E)Textbooks', details['(E)Textbooks']),
                      // _buildRow('(E)Language of Instruction',
                      //     details['(E)Language of Instruction']),
                      // _buildRow('(E)Note', details['(E)Note']),
                      // _buildRow('(E)Requirements for registration',
                      //     details['(E)Requirements for registration']),
                      // _buildRow('(E)Type of class and exam',
                      //     details['(E)Type of class and exam']),
                    ],
                  ),
                );
              },
            );
          } else {
            return createProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _buildRow(BuildContext context, String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: '$title: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: value ?? '情報がありません',
                style: DefaultTextStyle.of(context).style, // 通常のスタイルに戻す
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
