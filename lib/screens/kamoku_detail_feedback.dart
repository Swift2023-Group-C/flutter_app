import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_app/repository/get_feedbacklist.dart';
import 'package:flutter_app/components/setting_user_info.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class KamokuFeedbackScreen extends StatefulWidget {
  const KamokuFeedbackScreen({Key? key, required this.lessonId})
      : super(key: key);

  final int lessonId;

  @override
  // ignore: library_private_types_in_public_api
  _KamokuFeedbackScreenState createState() => _KamokuFeedbackScreenState();
}

class _KamokuFeedbackScreenState extends State<KamokuFeedbackScreen> {
  final userController = TextEditingController();
  double? selectedScore;
  final detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: FeedbackList(lessonId: widget.lessonId),
            ),
            Column(
              children: [
                ElevatedButton(
                  child: const Text('投稿'),
                  onPressed: () {
                    _showCustomDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('満足度'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                onRatingUpdate: (rating) {
                  selectedScore = rating;
                },
              ),
              const Row(
                children: [
                  Text('フィードバック (推奨)'),
                ],
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: '単位、出席、テストの情報など...',
                ),
                controller: detailController,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final String? userKey = await UserPreferences.getUserKey();
                  if (userKey != "" && selectedScore != null) {
                    // Firestoreで同じUserKeyとlessonIdを持つフィードバックを検索
                    final querySnapshot = await FirebaseFirestore.instance
                        .collection('feedback')
                        .where('User', isEqualTo: userKey)
                        .where('lessonId', isEqualTo: widget.lessonId)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      // 既存のフィードバックが存在してたらそれを更新
                      final docId = querySnapshot.docs[0].id;
                      FirebaseFirestore.instance
                          .collection('feedback')
                          .doc(docId)
                          .update({
                        'score': selectedScore,
                        'detail': detailController.text,
                      });
                    } else {
                      // 既存のフィードバックが存在しなかったら新しいドキュメントを作成
                      FirebaseFirestore.instance.collection('feedback').add({
                        'User': userKey,
                        'lessonId': widget.lessonId,
                        'score': selectedScore,
                        'detail': detailController.text,
                      });
                    }
                  }

                  // テキストフィールドと選択をクリア
                  userController.clear();
                  setState(() {
                    selectedScore = null;
                  });
                  detailController.clear();
                },
                child: const Text('投稿する'),
              ),
            ],
          ),
        );
      },
    );
  }
}
