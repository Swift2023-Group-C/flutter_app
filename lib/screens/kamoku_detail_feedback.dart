import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/firebase_options.dart';
import 'package:dotto/repository/get_feedbacklist.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dotto/components/color_fun.dart';

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
  bool showErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          if (FirebaseAuth.instance.currentUser != null) {
            _showCustomDialog(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('未来大Googleアカウントでログインが必要です')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    // ダイアログを開くたびにエラーメッセージをリセット
    showErrorMessage = false;
    detailController.clear();

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final dialogHeight = deviceHeight * 0.30;
    final dialogWidth = deviceWidth;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            // StatefulBuilderとやら
            builder: (BuildContext context, StateSetter setState) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: AlertDialog(
                  insetPadding: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '満足度(必須)',
                                style: TextStyle(
                                  fontSize: dialogWidth * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: customFunColor,
                                ),
                              ),
                            ),
                            SizedBox(width: dialogWidth * 0.1),
                            //星のバー
                            RatingBar.builder(
                              minRating: 1,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              onRatingUpdate: (rating) {
                                selectedScore = rating;
                              },
                              itemSize: dialogWidth * 0.075,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                          child: Text(
                            showErrorMessage ? '満足度が入力されていません' : '',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: dialogHeight * 0.045),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'フィードバック (推奨)',
                            style: TextStyle(
                                fontSize: dialogWidth * 0.03,
                                color: customFunColor),
                          ),
                        ),
                        SizedBox(
                          width: deviceWidth * 0.9,
                          height: dialogWidth * 0.28,
                          child: TextFormField(
                            maxLines: 2,
                            maxLength: 30,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.start,
                              border: const OutlineInputBorder(),
                              hintText: '単位、出席、テストの情報など...',
                              hintStyle:
                                  TextStyle(fontSize: dialogHeight * 0.05),
                            ),
                            controller: detailController,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: dialogWidth * 0.3,
                              height: dialogHeight * 0.15,
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: customFunColor,
                                  side: const BorderSide(
                                    color: customFunColor, // 色 // 太さ
                                  ),
                                ),
                                onPressed: () {
                                  selectedScore = null;
                                  Navigator.of(context).pop();
                                },
                                child: const Text('閉じる'),
                              ),
                            ),
                            SizedBox(width: deviceWidth * 0.1),
                            SizedBox(
                              width: dialogWidth * 0.3,
                              height: dialogHeight * 0.15,
                              child: ElevatedButton(
                                onPressed: () async {
                                  //以下処理
                                  final String? userKey =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (userKey != "" && selectedScore != null) {
                                    // Firestoreで同じUserKeyとlessonIdを持つフィードバックを検索
                                    final querySnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('feedback')
                                            .where('User', isEqualTo: userKey)
                                            .where('lessonId',
                                                isEqualTo: widget.lessonId)
                                            .get();

                                    if (querySnapshot.docs.isNotEmpty) {
                                      // 既存のフィードバックが存在してたらそれを更新
                                      final docId = querySnapshot.docs[0].id;
                                      FirebaseFirestore.instance
                                          .collection('feedback')
                                          .doc(docId)
                                          .update(
                                        {
                                          'score': selectedScore,
                                          'detail': detailController.text,
                                        },
                                      );
                                    } else {
                                      // 既存のフィードバックが存在しなかったら新しいドキュメントを作成
                                      FirebaseFirestore.instance
                                          .collection('feedback')
                                          .add(
                                        {
                                          'User': userKey,
                                          'lessonId': widget.lessonId,
                                          'score': selectedScore,
                                          'detail': detailController.text,
                                        },
                                      );
                                    }
                                    // テキストフィールドと選択をクリア
                                    userController.clear();
                                    selectedScore = null;
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  } else {
                                    setState(() {
                                      // エラーメッセージを表示するための状態の更新
                                      showErrorMessage = true;
                                    });
                                  }
                                },
                                child: const Text(
                                  '投稿する',
                                ),
                              ),
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
        });
  }
}
