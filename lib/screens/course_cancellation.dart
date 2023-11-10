import 'package:flutter/material.dart';
import 'dart:convert';
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
    // JSONファイルのダウンロード
    _jsonContent = readJsonFile('home/cancel_lecture.json');
    print(_jsonContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('休講情報'),
      ),
      body: FutureBuilder<String>(
        future: _jsonContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('エラー: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              dynamic jsonData = jsonDecode(snapshot.data!);
              print(jsonData);
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
