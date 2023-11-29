import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_app/repository/read_json_file.dart';
import 'package:flutter_app/components/widgets/progress_indicator.dart';

class CourseCancellationScreen extends StatefulWidget {
  const CourseCancellationScreen({Key? key}) : super(key: key);

  @override
  State<CourseCancellationScreen> createState() =>
      _CourseCancellationScreenState();
}

class _CourseCancellationScreenState extends State<CourseCancellationScreen> {
  late Future<String> _jsonContent;
  String _selectedType = "すべて"; // 初期値は "すべて" としています

  @override
  void initState() {
    super.initState();
    // JSONファイルのダウンロード
    _jsonContent = readJsonFile('home/cancel_lecture.json');
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
              String jsonData = snapshot.data ?? ''; // もし null なら空文字列に設定

              try {
                List<dynamic> decodedData = jsonDecode(jsonData);

                // タイプごとにフィルタリング
                List<dynamic> filteredData = _selectedType == "すべて"
                    ? decodedData
                    : decodedData
                        .where((item) => item['type'] == _selectedType)
                        .toList();

                // 実際にはListView.builderなどを使ってデータを表示するウィジェットを構築することができます
                return Column(
                  children: [
                    DropdownButton<String>(
                      value: _selectedType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedType = newValue!;
                        });
                      },
                      items: <String>[
                        'すべて',
                        '補講あり',
                        '補講なし',
                        '補講未定',
                        'その他',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    createListView(filteredData),
                  ],
                );
              } catch (e) {
                return Center(child: Text('JSONデコードエラー: $e'));
              }
            }
          }
          return Center(child: createProgressIndicator());
        },
      ),
    );
  }

  Widget createListView(List<dynamic> data) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> item = data[index];

          // 各データをリストタイルで表示
          return ListTile(
            title: Text('日付: ${item['date']}'),
            subtitle: Text(
                '時限: ${item['period']}\n授業名: ${item['lessonName']}\nキャンパス: ${item['campus']}\n担当教員: ${item['staff']}\nタイプ: ${item['type']}\nコメント: ${item['comment']}'),
            // 他のウィジェットやアクションを追加することも可能
            onTap: () {
              // タップ時の処理を追加
            },
          );
        },
      ),
    );
  }
}
