import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../screens/kamoku_detail_page_view.dart';
import 'package:flutter_app/components/syllabus_db_config.dart';

//sort用のDB取得
Future<List<Map<String, dynamic>>> fetchRecords() async {
  Database database = await openDatabase(SyllabusDBConfig.dbPath);
  List<Map<String, dynamic>> records =
      await database.rawQuery('SELECT * FROM sort');
  return records;
}

//授業名でdetailDBを検索
Future<Map<String, dynamic>> fetchDetails(int lessonId) async {
  Database database = await openDatabase(SyllabusDBConfig.dbPath);
  List<Map<String, dynamic>> details = await database
      .query('detail', where: 'LessonId = ?', whereArgs: [lessonId]);

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
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: '授業名を検索',
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
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
  State<SearchResults> createState() => _SearchResultsState();
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
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return KamokuDetailPageScreen(
                    lessonId: record['LessonId'],
                    lessonName: record['授業名'],
                  );
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const Offset begin = Offset(1.0, 0.0); // 右から左
                  const Offset end = Offset.zero;
                  final Animatable<Offset> tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: Curves.easeInOut));
                  final Animation<Offset> offsetAnimation =
                      animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

Future<List<Map<String, dynamic>>> search(
    {required List<int> term,
    required List<int> grade,
    required List<int> courseStr,
    required List<int> classification,
    required List<int> education}) async {
  Database database = await openDatabase(SyllabusDBConfig.dbPath);
  String sqlWhere = "";
  String sqlWhere1 = "";
  String sqlWhere2 = "";
  String sqlWhere3 = "";
  String sqlWhere4 = "";
  String sqlWhere5 = "";

  List<int> kyoyokubun = [];

  if (term.isNotEmpty) {
    for (int i = 0; i < term.length; i++) {
      if (term[i] == 0) {
        sqlWhere1 += "( sort.開講時期=10";
      }
      if (term[i] == 1) {
        if (sqlWhere1 != "") {
          sqlWhere1 += " OR sort.開講時期=20";
        } else {
          sqlWhere1 += "( sort.開講時期=20";
        }
      }
      if (term[i] == 2) {
        if (sqlWhere1 != "") {
          sqlWhere1 += " OR sort.開講時期=0";
        } else {
          sqlWhere1 += "( sort.開講時期=0";
        }
      }
    }
    sqlWhere1 += " )";
  }
  sqlWhere += sqlWhere1;
  if (grade.isNotEmpty) {
    if (sqlWhere != "") {
      sqlWhere += " AND ";
    }
    for (int i = 0; i < grade.length; i++) {
      if (grade[i] == 0) {
        sqlWhere2 += "( sort.一年次=1";
        courseStr.clear();
      }
      if (grade[i] == 1) {
        if (sqlWhere2 != "") {
          sqlWhere2 += " OR sort.二年次=1";
        } else {
          sqlWhere2 += "( sort.二年次=1";
        }
      }
      if (grade[i] == 2) {
        if (sqlWhere2 != "") {
          sqlWhere2 += " OR sort.三年次=1";
        } else {
          sqlWhere2 += "( sort.三年次=1";
        }
      }
      if (grade[i] == 3) {
        if (sqlWhere2 != "") {
          sqlWhere2 += " OR sort.四年次=1";
        } else {
          sqlWhere2 += "( sort.四年次=1";
        }
      }
      if (grade[i] == 4) {
        kyoyokubun = education;
        if (sqlWhere2 != "") {
          sqlWhere2 += " OR sort.教養!=0";
        } else {
          sqlWhere2 += "( sort.教養!=0";
        }
      }
      if (grade[i] == 5) {
        if (sqlWhere2 != "") {
          sqlWhere2 += " OR sort.専門=1";
        } else {
          sqlWhere2 += "( sort.専門=1";
        }
      }
    }
    sqlWhere2 += " )";
  }
  sqlWhere += sqlWhere2;
  if (courseStr.isNotEmpty) {
    if (sqlWhere != "") {
      sqlWhere += " AND ";
    }
    for (int i = 0; i < courseStr.length; i++) {
      if (courseStr[i] == 0) {
        sqlWhere3 += "( sort.情報システムコース!=0";
      }
      if (courseStr[i] == 1) {
        if (sqlWhere3 != "") {
          sqlWhere3 += " OR sort.情報デザインコース!=0";
        } else {
          sqlWhere3 += "( sort.情報デザインコース!=0";
        }
      }
      if (courseStr[i] == 2) {
        if (sqlWhere3 != "") {
          sqlWhere3 += " OR sort.複雑コース!=0";
        } else {
          sqlWhere3 += "( sort.複雑コース!=0";
        }
      }
      if (courseStr[i] == 3) {
        if (sqlWhere3 != "") {
          sqlWhere3 += " OR sort.知能システムコース!=0";
        } else {
          sqlWhere3 += "( sort.知能システムコース!=0";
        }
      }
      if (courseStr[i] == 4) {
        if (sqlWhere3 != "") {
          sqlWhere3 += " OR sort.高度ICTコース!=0";
        } else {
          sqlWhere3 += "( sort.高度ICTコース!=0";
        }
      }
    }
    sqlWhere3 += " )";
  }
  sqlWhere += sqlWhere3;
  if (classification.isNotEmpty) {
    if (sqlWhere != "") {
      sqlWhere += " AND ";
    }
    for (int i = 0; i < classification.length; i++) {
      if (classification[i] == 0) {
        sqlWhere4 +=
            "( sort.情報システムコース=101 OR sort.情報デザインコース=101 OR sort.複雑コース=101 OR sort.知能システムコース=101 OR sort.高度ICTコース=101";
      }
      if (classification[i] == 1) {
        if (sqlWhere4 != "") {
          sqlWhere4 +=
              " OR sort.情報システムコース=100 OR sort.情報デザインコース=100 OR sort.複雑コース=100 OR sort.知能システムコース=100 OR sort.高度ICTコース=100 OR sort.教養必修=1";
        } else {
          sqlWhere4 +=
              "( sort.情報システムコース=100 OR sort.情報デザインコース=100 OR sort.複雑コース=100 OR sort.知能システムコース=100 OR sort.高度ICTコース=100 OR sort.教養必修=1";
        }
      }
    }
    sqlWhere4 += " )";
  }
  sqlWhere += sqlWhere4;
  if (kyoyokubun.isNotEmpty) {
    if (sqlWhere != "") {
      sqlWhere += " AND ";
    }
    for (int i = 0; i < kyoyokubun.length; i++) {
      if (kyoyokubun[i] == 0) {
        sqlWhere5 += "( sort.教養=2";
      }
      if (kyoyokubun[i] == 1) {
        if (sqlWhere5 != "") {
          sqlWhere5 += " OR sort.教養=1";
        } else {
          sqlWhere5 += "( sort.教養=1";
        }
      }
      if (kyoyokubun[i] == 2) {
        if (sqlWhere5 != "") {
          sqlWhere5 += " OR sort.教養=3";
        } else {
          sqlWhere5 += "( sort.教養=3";
        }
      }
      if (kyoyokubun[i] == 3) {
        if (sqlWhere5 != "") {
          sqlWhere5 += " OR sort.教養=4";
        } else {
          sqlWhere5 += "( sort.教養=4";
        }
      }
      if (kyoyokubun[i] == 4) {
        if (sqlWhere5 != "") {
          sqlWhere5 += " OR sort.教養=5";
        } else {
          sqlWhere5 += "( sort.教養=5";
        }
      }
    }
    sqlWhere5 += " )";
  }
  sqlWhere += sqlWhere5;
  if (sqlWhere != "") {
    List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT detail.LessonId,detail.授業名 FROM sort detail INNER JOIN sort ON sort.LessonId=detail.LessonId WHERE $sqlWhere ');
    return records;
  } else {
    List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT detail.LessonId,detail.授業名 FROM sort detail INNER JOIN sort ON sort.LessonId=detail.LessonId');
    return records;
  }
}
