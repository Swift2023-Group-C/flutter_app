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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCustomDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: const Text('満足度(必須)'),
            content: SizedBox(
              height: deviceHeight * 0.3,
              width: deviceWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RatingBar.builder(
                    minRating: 1,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    onRatingUpdate: (rating) {
                      selectedScore = rating;
                    },
                  ),
                  const Spacer(),
                  const Text('フィードバック (推奨)'),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    child: TextFormField(
                      maxLines: 3,
                      maxLength: 30,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '単位、出席、テストの情報など...',
                      ),
                      controller: detailController,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final String? userKey =
                              await UserPreferences.getUserKey();
                          if (userKey != "" && selectedScore != null) {
                            // Firestoreで同じUserKeyとlessonIdを持つフィードバックを検索
                            final querySnapshot = await FirebaseFirestore
                                .instance
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
                              FirebaseFirestore.instance
                                  .collection('feedback')
                                  .add({
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
                          Navigator.pop(context);
                        },
                        child: const Text('投稿する'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
