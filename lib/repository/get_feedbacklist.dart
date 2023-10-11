import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackList extends StatefulWidget {
  const FeedbackList({Key? key, required this.lessonId}) : super(key: key);

  final int lessonId;

  @override
  State<FeedbackList> createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  double averageScore = 0.0; // 平均値を保持する変数

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('feedback')
          .where('lessonId', isEqualTo: widget.lessonId)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('エラー: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          final QuerySnapshot<Map<String, dynamic>> querySnapshot =
              snapshot.data!;
          final List<DocumentSnapshot<Map<String, dynamic>>> documents =
              querySnapshot.docs;

          if (documents.isEmpty) {
            return const Text('データがありません');
          }

          // scoreの合計を計算
          double totalScore = 0.0;
          for (final document in documents) {
            final score = document.get('score') ?? 0.0;
            totalScore += score;
          }

          // 平均値を計算
          averageScore = totalScore / documents.length;

          return Column(
            children: [
              Text('平均満足度: ${averageScore.toStringAsFixed(2)}'),
              Expanded(
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final document = documents[index];
                    final detail = document.get('detail');
                    final score = document.get('score');

                    return ListTile(
                      title: Text('満足度:$score, 内容: $detail'),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const Text('データがありません');
      },
    );
  }
}
