import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/components/widgets/progress_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackList extends StatefulWidget {
  const FeedbackList({Key? key, required this.lessonId}) : super(key: key);

  final int lessonId;

  @override
  State<FeedbackList> createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  double averageScore = 0.0;

  double _computeAverageScore(
      List<DocumentSnapshot<Map<String, dynamic>>> documents) {
    double totalScore = 0.0;
    for (final document in documents) {
      final score = (document.get('score') ?? 0.0).toDouble();
      totalScore += score;
    }
    return totalScore / documents.length;
  }

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
          return createProgressIndicator();
        }
        if (snapshot.hasData) {
          final querySnapshot = snapshot.data!;
          final documents = querySnapshot.docs;

          if (documents.isEmpty) {
            return const Text('データがありません');
          }

          averageScore = _computeAverageScore(documents);

          return Column(
            children: [
              Text('平均満足度: ${averageScore.toStringAsFixed(2)}'),
              Expanded(
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final document = documents[index];
                    final detail = document.get('detail');
                    final score = (document.get('score') ?? 0).toDouble();

                    return ListTile(
                      leading: RatingBarIndicator(
                        rating: score,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 15.0,
                      ),
                      title: Text('内容: $detail'),
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
