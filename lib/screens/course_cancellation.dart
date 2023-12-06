import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dotto/repository/read_json_file.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotto/repository/narrowed_lessons.dart';

class CourseCancellationScreen extends StatefulWidget {
  const CourseCancellationScreen({Key? key}) : super(key: key);

  @override
  State<CourseCancellationScreen> createState() =>
      _CourseCancellationScreenState();
}

class _CourseCancellationScreenState extends State<CourseCancellationScreen> {
  Future<List<dynamic>> filterJsonDataByLessonNames(WidgetRef ref) async {
    // 個人のタイムテーブルマップをロード
    Map<String, int> personalTimeTableMap =
        await loadPersonalTimeTableMapString(ref);

    String jsonFileName = 'home/cancel_lecture.json';
    // JSONファイルを読み込む
    String jsonData = await readJsonFile(jsonFileName);
    List<dynamic> decodedData = jsonDecode(jsonData);

    // デコードされたJSONデータをフィルタリング
    List<dynamic> filteredData = decodedData.where((item) {
      return personalTimeTableMap.keys.contains(item['lessonName']);
    }).toList();

    return filteredData;
  }

  Future<List<dynamic>> loadData(WidgetRef ref) async {
    String jsonData = await readJsonFile('home/cancel_lecture.json');
    List<dynamic> decodedData = jsonDecode(jsonData);

    if (isFilterEnabled) {
      return await filterJsonDataByLessonNames(ref);
    } else {
      return decodedData;
    }
  }

  String _selectedType = "すべて"; // 初期値は "すべて"
  bool isFilterEnabled = true; // 初期状態はフィルターされるように

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('休講情報'),
        actions: <Widget>[
          // フィルターのオン/オフを切り替えるボタン
          TextButton(
            onPressed: () {
              setState(() {
                isFilterEnabled = !isFilterEnabled;
              });
            },
            child: isFilterEnabled
                ? const Text(
                    '全科目表示',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    '取得している科目のみ表示',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return FutureBuilder<List<dynamic>>(
            future: loadData(ref),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text('エラー: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<dynamic> displayData = snapshot.data ?? [];

                  // タイプごとにフィルタリング
                  List<dynamic> filteredData = _selectedType == "すべて"
                      ? displayData
                      : displayData
                          .where((item) => item['type'] == _selectedType)
                          .toList();

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
                }
              }
              return Center(child: createProgressIndicator());
            },
          );
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
                '時限: ${item['period']}\n授業名: ${item['lessonName']}\nキャンパス: ${item['campus']}\n担当教員: ${item['staff']}\nコメント: ${item['comment']}'),
            // 他のウィジェットやアクションを追加することも可能
          );
        },
      ),
    );
  }
}
