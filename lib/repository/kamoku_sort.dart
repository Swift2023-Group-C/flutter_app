import 'package:flutter/material.dart';
import 'package:flutter_app/repository/narrowed_lessons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_app/screens/kamoku_detail_page_view.dart';
import 'package:flutter_app/components/db_config.dart';

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
    throw Exception();
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
    //loadPersonalTimeTableList();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
                    kakomonLessonId: record['過去問'],
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
          trailing: const Icon(Icons.chevron_right),
          leading: Consumer(
            builder: (context, ref, child) {
              final personalLessonIdList =
                  ref.watch(personalLessonIdListProvider);
              return IconButton(
                icon: Icon(Icons.playlist_add,
                    color: personalLessonIdList.contains(record['LessonId'])
                        ? Colors.green
                        : Colors.black),
                onPressed: () {
                  if (!personalLessonIdList.contains(record['LessonId'])) {
                    personalLessonIdList.add(record['LessonId']);
                    savePersonalTimeTableList(personalLessonIdList, ref);
                  } else {
                    personalLessonIdList
                        .removeWhere((item) => item == record['LessonId']);
                    savePersonalTimeTableList(personalLessonIdList, ref);
                  }
                },
              );
            },
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 0,
      ),
    );
  }
}

bool isNotAllTrueOrAllFalse(List<bool> list) {
  if (list.every((element) => element)) {
    return false;
  } else if (list.every((element) => !element)) {
    return false;
  } else {
    return true;
  }
}

Future<List<Map<String, dynamic>>> search(
    {required List<bool> term,
    required int senmon,
    required List<bool> grade,
    required List<bool> course,
    required List<bool> classification,
    required List<bool> education}) async {
  Database database = await openDatabase(SyllabusDBConfig.dbPath);
  List<String> sqlWhereList = [];
  List<String> sqlWhereListKyoyo = [];
  String sqlWhere = "";

  // 開講時期
  // ['前期', '後期', '通年']
  List<String> sqlWhereTerm = [];
  if (isNotAllTrueOrAllFalse(term)) {
    List<String> termName = ['10', '20', '0'];
    for (var i = 0; i < term.length; i++) {
      if (term[i]) {
        sqlWhereTerm.add(termName[i]);
      }
    }
    sqlWhereList.add("(sort.開講時期 IN (${sqlWhereTerm.join(", ")}))");
  }

  if (senmon == 0) {
    // 学年
    // ['1年', '2年', '3年', '4年']
    if (isNotAllTrueOrAllFalse(grade)) {
      List<String> sqlWhereGrade = [];
      List<String> gradeName = ['一年次', '二年次', '三年次', '四年次'];
      for (var i = 0; i < grade.length; i++) {
        if (grade[i]) {
          sqlWhereGrade.add("sort.${gradeName[i]}=1");
        }
      }
      sqlWhereList.add("(${sqlWhereGrade.join(" OR ")})");
    }

    // コース・専門
    // ['情シス', 'デザイン', '複雑', '知能', '高度ICT']
    // ['必修', '選択']
    List<String> sqlWhereCourseClassification = [];
    final List<String> courseName = [
      "情報システムコース",
      "情報デザインコース",
      "複雑コース",
      "知能システムコース",
      "高度ICTコース",
    ];
    final List<String> classificationName = ["100", "101"];
    if (isNotAllTrueOrAllFalse(course)) {
      for (int i = 0; i < course.length; i++) {
        if (course[i]) {
          if (isNotAllTrueOrAllFalse(classification)) {
            for (int j = 0; j < classification.length; j++) {
              if (classification[j]) {
                sqlWhereCourseClassification
                    .add("sort.${courseName[i]}=${classificationName[j]}");
              }
            }
          } else {
            // 必修選択関係なし
            sqlWhereCourseClassification.add("sort.${courseName[i]}!=0");
          }
        }
      }
    } else {
      sqlWhereCourseClassification.add("sort.専門=1");
    }
    if (sqlWhereCourseClassification.isNotEmpty) {
      sqlWhereList.add("(${sqlWhereCourseClassification.join(" OR ")})");
    }
  } else if (senmon == 1) {
    // 教養
    List<String> sqlWhereKyoyo = [];
    sqlWhereListKyoyo.add("(sort.教養!=0)");
    if (isNotAllTrueOrAllFalse(education)) {
      List<String> educationNo = ['2', '1', '3', '4', '5'];
      for (var i = 0; i < education.length; i++) {
        if (education[i]) {
          sqlWhereKyoyo.add("sort.教養=${educationNo[i]}");
        }
      }
      sqlWhereListKyoyo.add("(${sqlWhereKyoyo.join(" OR ")})");
    }
    if (isNotAllTrueOrAllFalse(classification)) {
      if (classification[0]) {
        sqlWhereListKyoyo.add("(sort.教養必修=1)");
      }
      if (classification[1]) {
        sqlWhereListKyoyo.add("(sort.教養必修!=1)");
      }
    }
    sqlWhereList.add("(${sqlWhereListKyoyo.join(" AND ")})");
  }

  if (sqlWhereList.isNotEmpty) {
    sqlWhere = sqlWhereList.join(" AND ");
  }

  debugPrint(sqlWhere);
  if (sqlWhere != "") {
    List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT * FROM sort detail INNER JOIN sort ON sort.LessonId=detail.LessonId WHERE $sqlWhere ');
    return records;
  } else {
    List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT * FROM sort detail INNER JOIN sort ON sort.LessonId=detail.LessonId');
    return records;
  }
}
