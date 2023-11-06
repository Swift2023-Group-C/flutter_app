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

  // 平均満足度の計算
  double _computeAverageScore(
      List<DocumentSnapshot<Map<String, dynamic>>> documents) {
    double totalScore = 0.0;
    for (final document in documents) {
      final score = (document.get('score') ?? 0.0).toDouble();
      totalScore += score;
    }
    return documents.isEmpty ? 0.0 : totalScore / documents.length;
  }

  // 各点の満足度の割合を計算
  double _percentageOfRating(
      List<DocumentSnapshot<Map<String, dynamic>>> documents, int rating) {
    int count = 0;
    for (final document in documents) {
      if (document.get('score') == rating) {
        count += 1;
      }
    }
    return documents.isEmpty ? 0.0 : count / documents.length;
  }

  // 満足度の分布を表すためのバー
  Widget _buildRatingBar(int rating, Color color, double widthFactor) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 20),
        Text('$rating'),
        const SizedBox(width: 10),
        Expanded(
          child: LinearProgressIndicator(
            value: widthFactor,
            valueColor: AlwaysStoppedAnimation(color),
            backgroundColor: Colors.grey[300],
          ),
        ),
      ],
    );
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
            return const Center(child: Text('データがありません'));
          }

          averageScore = _computeAverageScore(documents);

          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          averageScore.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            color: Colors.black,
                          ),
                        ),
                        RatingBarIndicator(
                          rating: averageScore,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 25.0,
                        ),
                        Text(
                          'BASED OF ${documents.length} REVIEWS',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildRatingBar(
                            5,
                            Colors.green,
                            _percentageOfRating(documents, 5),
                          ),
                          _buildRatingBar(
                            4,
                            Colors.green,
                            _percentageOfRating(documents, 4),
                          ),
                          _buildRatingBar(
                            3,
                            Colors.yellow,
                            _percentageOfRating(documents, 3),
                          ),
                          _buildRatingBar(
                            2,
                            Colors.orange,
                            _percentageOfRating(documents, 2),
                          ),
                          _buildRatingBar(
                            1,
                            Colors.red,
                            _percentageOfRating(documents, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // フィードバックリスト
                Expanded(
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final document = documents[index];
                      final detail = document.get('detail');
                      final score = (document.get('score') ?? 0).toDouble();

                      if (detail == null || detail.toString().trim().isEmpty) {
                        return const SizedBox
                            .shrink(); // detailがnullまたは空の場合は何も表示しない
                      }

                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 211, 211, 211), // 区切り線
                            ),
                          ),
                        ),
                        child: ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                          leading: RatingBarIndicator(
                            rating: score,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                          ),
                          title: Text(
                            '$detail',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('データがありません'));
      },
    );
  }
}
