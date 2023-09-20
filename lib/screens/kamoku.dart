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
      await database.rawQuery('SELECT LessonId,授業名 FROM test');
  return records;
}

Future<Map<String, dynamic>> fetchDetails(String className) async {
  String dbPath = await getDatabasesPath();
  String copiedDbPath = join(dbPath, 'コピーされたデータベース.db');

  Database database = await openDatabase(copiedDbPath);
  List<Map<String, dynamic>> details =
      await database.query('test', where: '授業名 = ?', whereArgs: [className]);

  if (details.isNotEmpty) {
    return details.first;
  } else {
    return {};
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
          Map<String, dynamic> details = snapshot.data!;
          // 詳細情報を表示するウィジェットを構築することができます
          // 例えば、Text ウィジェットを使用して詳細情報を表示することができます
          return ListView.builder(
            itemCount: 1, // リストアイテムは1つのみ
            itemBuilder: (context, index) {
              return ListTile(
                //title: Text('LessonId: ${details['LessonId']}'),
                title: Text(
                  '詳細情報',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
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
                    Text('授業・試験の形式: ${details['授業・試験の形式']}'),
                    Text('教授言語: ${details['教授言語']}'),
                    Text('DSOP対象科目: ${details['DSOP対象科目']}'),
                    Text('(E)Course outline: ${details['(E)Course outline']}'),
                    Text(
                        '(E)Course Objectives: ${details['(E)Course Objectives']}'),
                    Text(
                        '(E)Course Schedule: ${details['(E)Course Schedule']}'),
                    Text(
                        '(E)Prior/Post Assignment: ${details['(E)Prior/Post Assignment']}'),
                    Text('(E)Assessment: ${details['(E)Assessment']}'),
                    Text('(E)Textbooks: ${details['(E)Textbooks']}'),
                    Text(
                        '(E)Language of Instruction: ${details['(E)Language of Instruction']}'),
                    Text('(E)Note: ${details['(E)Note']}'),
                    Text(
                        '(E)Requirements for registration: ${details['(E)Requirements for registration']}'),
                    Text(
                        '(E)Type of class and exam: ${details['(E)Type of class and exam']}'),
                    // 他のカラムも同様に表示できます
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
