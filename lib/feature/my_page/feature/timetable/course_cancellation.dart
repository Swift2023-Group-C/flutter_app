import 'dart:convert';

import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/my_page/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/my_page/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/repository/read_json_file.dart';

class CourseCancellationScreen extends ConsumerWidget {
  const CourseCancellationScreen({super.key});

  Future<List<dynamic>> loadData(WidgetRef ref) async {
    final courseCancellationFilterEnabled = ref.watch(courseCancellationFilterEnabledProvider);
    try {
      final jsonData = await readJsonFile('home/cancel_lecture.json');
      List<dynamic> decodedData = jsonDecode(jsonData);

      if (courseCancellationFilterEnabled) {
        final personalTimeTableMap =
            await TimetableRepository().loadPersonalTimeTableMapString(ref);
        // デコードされたJSONデータをフィルタリング
        List<dynamic> filteredData = decodedData.where((item) {
          return personalTimeTableMap.keys.contains(item['lessonName']);
        }).toList();
        return filteredData;
      } else {
        return decodedData;
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('休講情報'),
        ),
        body: const Center(
          child: Text("未来大Googleアカウントでログインすると閲覧できます。"),
        ),
      );
    }
    final courseCancellationFilterEnabled = ref.watch(courseCancellationFilterEnabledProvider);
    final courseCancellationFilterEnabledNotifier =
        ref.read(courseCancellationFilterEnabledProvider.notifier);
    final courseCancellationSelectedType = ref.watch(courseCancellationSelectedTypeProvider);
    final courseCancellationSelectedTypeNotifier =
        ref.read(courseCancellationSelectedTypeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('休講情報'),
        actions: <Widget>[
          // フィルターのオン/オフを切り替えるボタン
          TextButton(
            onPressed: () {
              courseCancellationFilterEnabledNotifier.state = !courseCancellationFilterEnabled;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  courseCancellationFilterEnabled ? '全て表示' : '時間割にある科目のみ表示',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.sync_alt,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: loadData(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('エラー: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<dynamic> displayData = snapshot.data ?? [];

              // タイプごとにフィルタリング
              List<dynamic> filteredData = courseCancellationSelectedType == "すべて"
                  ? displayData
                  : displayData
                      .where((item) => item['type'] == courseCancellationSelectedType)
                      .toList();

              return Column(
                children: [
                  DropdownButton<String>(
                    value: courseCancellationSelectedType,
                    onChanged: (String? newValue) {
                      courseCancellationSelectedTypeNotifier.state = newValue ?? 'すべて';
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
      ),
    );
  }

  Widget createListView(List<dynamic> data) {
    if (data.isNotEmpty) {
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
    } else {
      return const Center(
        child: Text('休講補講情報はありません。\n右上から表示を切り替えることができます。'),
      );
    }
  }
}
