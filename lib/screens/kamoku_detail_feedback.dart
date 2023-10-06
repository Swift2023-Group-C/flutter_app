import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_app/repository/get_feedbacklist.dart';
import 'package:flutter_app/components/setting_user_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Firebaseの初期化前に呼び出す
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
  int? selectedScore; // 選択された満足度を保持する変数
  final detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<int>(
                  value: selectedScore,
                  onChanged: (value) {
                    setState(() {
                      selectedScore = value;
                    });
                  },
                  items:
                      [1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: detailController,
                  decoration: const InputDecoration(labelText: '詳細'),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final String? userKey = await UserPreferences.getUserKey();
                  if (userKey != "") {
                    // Firestoreにデータを追加
                    FirebaseFirestore.instance.collection('feedback').add({
                      'User': userKey,
                      'lessonId': widget.lessonId,
                      'score': selectedScore,
                      'detail': detailController.text,
                    });
                  }

                  // テキストフィールドと選択をクリア
                  userController.clear();
                  setState(() {
                    selectedScore = null;
                  });
                  detailController.clear();
                },
                child: const Text('追加'),
              )
            ],
          ),
          Expanded(
            child: FeedbackList(lessonId: widget.lessonId),
          ),
        ],
      ),
    );
  }
}
