import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Map<String, dynamic>>> fetchRecords() async {
  String dbPath = await getDatabasesPath();
  String assetDbPath = join('assets', 'a.db');
  String copiedDbPath = join(dbPath, 'コピーされたデータベース.db');

  ByteData data = await rootBundle.load(assetDbPath);
  List<int> bytes = data.buffer.asUint8List();
  await File(copiedDbPath).writeAsBytes(bytes);

  Database database = await openDatabase(copiedDbPath);
  List<Map<String, dynamic>> records =
      await database.rawQuery('SELECT LessonId,授業名 FROM database2');
  return records;
}

Future<Map<String, dynamic>> fetchDetails(String className) async {
  String dbPath = await getDatabasesPath();
  String copiedDbPath = join(dbPath, 'コピーされたデータベース.db');

  Database database = await openDatabase(copiedDbPath);
  List<Map<String, dynamic>> details = await database
      .query('database2', where: '授業名 = ?', whereArgs: [className]);

  //List<Map<String, dynamic>> info = await database
  //  .query('database2', where: 'LessonId = ?', whereArgs: [className]);

  if (details.isNotEmpty) {
    return details.first;
  } else {
    return {}; // エラーハンドリングを行うことを検討してください
  }
}

class KamokuScreen extends StatelessWidget {
  const KamokuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DB Test',
      home: Scaffold(
        body: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchRecords(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No data found');
              } else {
                List<Map<String, dynamic>> records = snapshot.data!;
                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(records[index]['授業名']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(className: records[index]['授業名']),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String className;

  DetailScreen({required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchDetails(className),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('詳細情報が見つかりません');
          } else {
            Map<String, dynamic> details = snapshot.data!;
            // 詳細情報を表示するウィジェットを構築することができます
            // 例えば、Text ウィジェットを使用して詳細情報を表示することができます
            return ListView.builder(
              itemCount: 1, // リストアイテムは1つのみ
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('LessonId: ${details['LessonId']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('授業名: ${details['授業名']}'),
                      Text('Course: ${details['Course']}'),
                      Text('配当年次: ${details['配当年次']}'),
                      Text('開講時期: ${details['開講時期']}'),
                      Text('単位数: ${details['単位数']}'),
                      Text('担当教員名: ${details['担当教員名']}'),
                      Text('実務家教員区分: ${details['実務家教員区分']}'),
                      Text('授業形態: ${details['授業形態']}'),
                      Text('授業の概要: ${details['授業の概要']}'),
                      Text('授業の到達目標: ${details['授業の到達目標']}'),
                      Text('提出課題等: ${details['提出課題等']}'),
                      Text('成績の評価方法・基準: ${details['成績の評価方法・基準']}'),
                      Text('テキスト: ${details['テキスト']}'),
                      Text('参考書: ${details['参考書']}'),
                      Text('履修条件: ${details['履修条件']}'),
                      Text('事前学習: ${details['事前学習']}'),
                      Text('事後学習: ${details['事後学習']}'),
                      Text('履修上の留意点: ${details['履修上の留意点']}'),
                      Text('キーワード/keyword: ${details['キーワード/keyword']}'),
                      Text('対象コース・領域: ${details['対象コース・領域']}'),
                      Text('科目群・科目区分: ${details['科目群・科目区分']}'),
                      // 他のカラムも同様に表示できます
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
