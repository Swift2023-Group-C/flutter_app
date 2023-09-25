import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//sort用のDB取得
Future<List<Map<String, dynamic>>> fetchRecords() async {
  String dbPath = await getDatabasesPath();
  String assetDbPath = join('assets', 'syllabus.db');
  String copiedDbPath = join(dbPath, 'コピーされたデータベース.db');

  ByteData data = await rootBundle.load(assetDbPath);
  List<int> bytes = data.buffer.asUint8List();
  await File(copiedDbPath).writeAsBytes(bytes);

  Database database = await openDatabase(copiedDbPath);
  List<Map<String, dynamic>> records =
      await database.rawQuery('SELECT * FROM sort');
  return records;
}

//授業名でdetailDBを検索
Future<Map<String, dynamic>> fetchDetails(String className) async {
  String dbPath = await getDatabasesPath();
  String copiedDbPath = join(dbPath, 'コピーされたデータベース.db');

  Database database = await openDatabase(copiedDbPath);
  List<Map<String, dynamic>> details =
      await database.query('detail', where: '授業名 = ?', whereArgs: [className]);

  if (details.isNotEmpty) {
    return details.first;
  } else {
    return {};
  }
}

//サーチボックスの仕様
class SearchBox extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBox({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: '授業名を検索',
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            widget.onSearch(_searchController.text);
          },
        ),
      ),
    );
  }
}

class SearchResults extends StatefulWidget {
  final List<Map<String, dynamic>> records;

  const SearchResults({Key? key, required this.records}) : super(key: key);

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

//授業名を検索するときのシステム
class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.records.length,
      itemBuilder: (context, index) {
        final record = widget.records[index];
        return ListTile(
          title: Text(record['授業名'] ?? ''),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(className: record['授業名']),
              ),
            );
          },
        );
      },
    );
  }
}

//チェックボックスで絞り込んだ後の画面表示
class _SortResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.records.length,
      itemBuilder: (context, index) {
        final record = widget.records[index];
        return ListTile(
          title: Text(record['授業名'] ?? ''),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(className: record['授業名']),
              ),
            );
          },
        );
      },
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
          return ListView.builder(
            itemCount: 1,
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

Future<List<Map<String, dynamic>>> search(
    {required List<int> term,
    required List<int> grade,
    required List<int> courseStr,
    required List<int> classification,
    required List<int> education}) async {
  String dbPath = await getDatabasesPath();
  String assetDbPath = join('assets', 'syllabus.db');
  String copiedDbPath = join(dbPath, 'コピーされたデータベース.db');

  ByteData data = await rootBundle.load(assetDbPath);
  List<int> bytes = data.buffer.asUint8List();
  await File(copiedDbPath).writeAsBytes(bytes);

  Database database = await openDatabase(copiedDbPath);
  String sql_where = "";
  String sql_where1 = "";
  String sql_where2 = "";
  String sql_where3 = "";
  String sql_where4 = "";
  String sql_where5 = "";

  List<int> kyoyokubun = [];

  if (term.length > 0) {
    for (int i = 0; i < term.length; i++) {
      if (term[i] == 0) {
        sql_where1 += "( sort.開講時期=10";
      }
      if (term[i] == 1) {
        if (sql_where1 != "") {
          sql_where1 += " OR sort.開講時期=20";
        } else {
          sql_where1 += "( sort.開講時期=20";
        }
      }
      if (term[i] == 2) {
        if (sql_where1 != "") {
          sql_where1 += " OR sort.開講時期=0";
        } else {
          sql_where1 += "( sort.開講時期=0";
        }
      }
    }
    sql_where1 += " )";
  }
  sql_where += sql_where1;
  if (grade.length > 0) {
    if (sql_where != "") {
      sql_where += " AND ";
    }
    for (int i = 0; i < grade.length; i++) {
      if (grade[i] == 0) {
        sql_where2 += "( sort.一年次=1";
        courseStr.clear();
      }
      if (grade[i] == 1) {
        if (sql_where2 != "") {
          sql_where2 += " OR sort.二年次=1";
        } else {
          sql_where2 += "( sort.二年次=1";
        }
      }
      if (grade[i] == 2) {
        if (sql_where2 != "") {
          sql_where2 += " OR sort.三年次=1";
        } else {
          sql_where2 += "( sort.三年次=1";
        }
      }
      if (grade[i] == 3) {
        if (sql_where2 != "") {
          sql_where2 += " OR sort.四年次=1";
        } else {
          sql_where2 += "( sort.四年次=1";
        }
      }
      if (grade[i] == 4) {
        kyoyokubun = education;
        if (sql_where2 != "") {
          sql_where2 += " OR sort.教養!=0";
        } else {
          sql_where2 += "( sort.教養!=0";
        }
      }
      if (grade[i] == 5) {
        if (sql_where2 != "") {
          sql_where2 += " OR sort.専門=1";
        } else {
          sql_where2 += "( sort.専門=1";
        }
      }
    }
    sql_where2 += " )";
  }
  sql_where += sql_where2;
  if (courseStr.length > 0) {
    if (sql_where != "") {
      sql_where += " AND ";
    }
    for (int i = 0; i < courseStr.length; i++) {
      if (courseStr[i] == 0) {
        sql_where3 += "( sort.情報システムコース!=0";
      }
      if (courseStr[i] == 1) {
        if (sql_where3 != "") {
          sql_where3 += " OR sort.情報デザインコース!=0";
        } else {
          sql_where3 += "( sort.情報デザインコース!=0";
        }
      }
      if (courseStr[i] == 2) {
        if (sql_where3 != "") {
          sql_where3 += " OR sort.複雑コース!=0";
        } else {
          sql_where3 += "( sort.複雑コース!=0";
        }
      }
      if (courseStr[i] == 3) {
        if (sql_where3 != "") {
          sql_where3 += " OR sort.知能システムコース!=0";
        } else {
          sql_where3 += "( sort.知能システムコース!=0";
        }
      }
      if (courseStr[i] == 4) {
        if (sql_where3 != "") {
          sql_where3 += " OR sort.高度ICTコース!=0";
        } else {
          sql_where3 += "( sort.高度ICTコース!=0";
        }
      }
    }
    sql_where3 += " )";
  }
  sql_where += sql_where3;
  if (classification.length > 0) {
    if (sql_where != "") {
      sql_where += " AND ";
    }
    for (int i = 0; i < classification.length; i++) {
      if (classification[i] == 0) {
        sql_where4 +=
            "( sort.情報システムコース=101 OR sort.情報デザインコース=101 OR sort.複雑コース=101 OR sort.知能システムコース=101 OR sort.高度ICTコース=101";
      }
      if (classification[i] == 1) {
        if (sql_where4 != "") {
          sql_where4 +=
              " OR sort.情報システムコース=100 OR sort.情報デザインコース=100 OR sort.複雑コース=100 OR sort.知能システムコース=100 OR sort.高度ICTコース=100 OR sort.教養必修=1";
        } else {
          sql_where4 +=
              "( sort.情報システムコース=100 OR sort.情報デザインコース=100 OR sort.複雑コース=100 OR sort.知能システムコース=100 OR sort.高度ICTコース=100 OR sort.教養必修=1";
        }
      }
    }
    sql_where4 += " )";
  }
  sql_where += sql_where4;
  if (kyoyokubun.length > 0) {
    if (sql_where != "") {
      sql_where += " AND ";
    }
    for (int i = 0; i < kyoyokubun.length; i++) {
      if (kyoyokubun[i] == 0) {
        sql_where5 += "( sort.教養=2";
      }
      if (kyoyokubun[i] == 1) {
        if (sql_where5 != "") {
          sql_where5 += " OR sort.教養=1";
        } else {
          sql_where5 += "( sort.教養=1";
        }
      }
      if (kyoyokubun[i] == 2) {
        if (sql_where5 != "") {
          sql_where5 += " OR sort.教養=3";
        } else {
          sql_where5 += "( sort.教養=3";
        }
      }
      if (kyoyokubun[i] == 3) {
        if (sql_where5 != "") {
          sql_where5 += " OR sort.教養=4";
        } else {
          sql_where5 += "( sort.教養=4";
        }
      }
      if (kyoyokubun[i] == 4) {
        if (sql_where5 != "") {
          sql_where5 += " OR sort.教養=5";
        } else {
          sql_where5 += "( sort.教養=5";
        }
      }
    }
    sql_where5 += " )";
  }
  sql_where += sql_where5;
  if (sql_where != "") {
    List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT detail.LessonId,detail.授業名 FROM sort detail INNER JOIN sort ON sort.LessonId=detail.LessonId WHERE $sql_where');
    return records;
  } else {
    List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT detail.LessonId,detail.授業名 FROM sort detail INNER JOIN sort ON sort.LessonId=detail.LessonId');
    return records;
  }
}
