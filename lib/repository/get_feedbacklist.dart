import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackList extends StatelessWidget {
  const FeedbackList({Key? key, required this.lessonId});

  final int lessonId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('feedback')
          .where('lessonId', isEqualTo: lessonId) // 条件を指定
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
          print(documents);
          if (documents.isEmpty) {
            return const Text('データがありません');
          }

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              final document = documents[index];
              final detail = document.get('detail');
              final score = document.get('score');
              print(score);

              return ListTile(
                title: Text('満足度:$score, 内容: $detail'),
              );
            },
          );
        }

        return const Text('データがありません');
      },
    );
  }
}
