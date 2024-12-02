import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/kamoku_detail/repository/kamoku_detail_repository.dart';
import 'package:dotto/feature/kamoku_detail/widget/kamoku_detail_feedback_list.dart';

class KamokuFeedbackScreen extends StatefulWidget {
  const KamokuFeedbackScreen({super.key, required this.lessonId});

  final int lessonId;

  @override
  State<KamokuFeedbackScreen> createState() => _KamokuFeedbackScreenState();
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
              child: KamokuDetailFeedbackList(lessonId: widget.lessonId),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (KamokuDetailRepository().isLoggedinGoogle()) {
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
                surfaceTintColor: Theme.of(context).colorScheme.surface,
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
                            glow: false,
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
                          style: TextStyle(color: Colors.red, fontSize: dialogHeight * 0.045),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'フィードバック (推奨)',
                          style: TextStyle(fontSize: dialogWidth * 0.03, color: customFunColor),
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
                            floatingLabelAlignment: FloatingLabelAlignment.start,
                            border: const OutlineInputBorder(),
                            hintText: '単位、出席、テストの情報など...',
                            hintStyle: TextStyle(fontSize: dialogHeight * 0.05),
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
                                surfaceTintColor: Colors.white,
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
                              style: TextButton.styleFrom(
                                backgroundColor: customFunColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                if (await KamokuDetailRepository().postFeedback(
                                  widget.lessonId,
                                  selectedScore,
                                  detailController.text,
                                )) {
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
      },
    );
  }
}
