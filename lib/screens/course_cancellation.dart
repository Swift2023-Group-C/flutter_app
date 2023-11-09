import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_app/repository/download_file_from_firebase.dart';
import 'package:flutter_app/repository/read_json_file.dart';
import 'package:flutter_app/components/widgets/progress_indicator.dart';

class CourseCancellationScreen extends StatefulWidget {
  const CourseCancellationScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CourseCancellationScreenState createState() =>
      _CourseCancellationScreenState();
}

class _CourseCancellationScreenState extends State<CourseCancellationScreen> {
  late Future<String> _jsonContent;

  @override
  void initState() {
    super.initState();
    // ファイルダウンロードと読み込みの処理を開始
    _jsonContent = downloadAndReadJson('home/cancel_lecture.json');
  }

  Future<String> downloadAndReadJson(String firebaseFilePath) async {
    await downloadFileFromFirebase(firebaseFilePath); // Firebaseからファイルをダウンロード
    return readJsonFile(firebaseFilePath); // ファイルの内容を読む
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _jsonContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('エラー: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              dynamic jsonData = jsonDecode(snapshot.data!);
              return SingleChildScrollView(
                child: Text(jsonData.toString()),
              );
            }
          }
          return createProgressIndicator();
        },
      ),
    );
  }
}
