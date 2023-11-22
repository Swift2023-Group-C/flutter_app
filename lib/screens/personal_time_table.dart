import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/db_config.dart';
import 'package:flutter_app/components/setting_user_info.dart';
import 'dart:convert';
import 'package:flutter_app/components/color_fun.dart';
import 'package:sqflite/sqflite.dart';

class PersonalTimeTableScreen extends StatefulWidget {
  const PersonalTimeTableScreen({Key? key}) : super(key: key);

  @override
  State<PersonalTimeTableScreen> createState() =>
      _PersonalTimeTableScreenState();
}

class _PersonalTimeTableScreenState extends State<PersonalTimeTableScreen> {
  List<int> personalTimeTableList = [];
  late List<Map<String, dynamic>> records = [];
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  Future<void> loadPersonalTimeTableList() async {
    final jsonString = await UserPreferences.getFinishList();
    if (jsonString != null) {
      setState(() {
        personalTimeTableList = List<int>.from(json.decode(jsonString));
      });
    }
  }

  Future<void> savePersonalTimeTableList() async {
    await UserPreferences.setFinishList(json.encode(personalTimeTableList));
  }

  Future<List<Map<String, dynamic>>> fetchRecords() async {
    Database database = await openDatabase(SyllabusDBConfig.dbPath);

    // String whereClause = personalTimeTableList.map((id) => '?').join(', ');
    // List<Map<String, dynamic>> records = await database.query(
    //   'week_period',
    //   where: 'lessonID IN ($whereClause)',
    //   whereArgs: personalTimeTableList,
    // );
    List<Map<String, dynamic>> records =
        await database.rawQuery('SELECT * FROM week_period');
    return records;
  }

  /*Widget seasonTimeTableList(   ListView表示のやつ
      int seasonnumber, List<Map<String, dynamic>> records) {
    List<Map<String, dynamic>> seasonList = records.where((record) {
      return record['開講時期'] == seasonnumber || record['開講時期'] == 0;
    }).toList();
    return ListView.builder(
      itemCount: seasonList.length,
      itemBuilder: (context, index) {
        var record = seasonList[index];
        return ListTile(
          title: Text(record['授業名'] ?? '不明な授業'),
          /* よくわからなくなったので保留
          leading: IconButton(
              onPressed: () async {
                setState(() {
                  personalTimeTableList
                      .removeWhere((item) => item == record['LessonId']);
                });
                await savePersonalTimeTableList();
                var updatedRecords = await fetchRecords();
                setState(() {
                  records = updatedRecords;
                });
                print(personalTimeTableList);
              },
              icon: const Icon(Icons.playlist_remove)),*/
        );
      },
    );
  }*/

  void seasonTimeTable(List<Map<String, dynamic>> records) {
    List<Map<String, dynamic>> seasonList = records.where((record) {
      return personalTimeTableList.contains(record['lessonId']);
    }).toList();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("取得してる科目一覧"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: personalTimeTableList.length,
                itemBuilder: (context, Index) {
                  return ListTile(
                    title: Text(seasonList[Index]['授業名']),
                  );
                },
              ),
            ),
          );
        });
  }

  InkWell tableText(
      String name, int week, period, List<Map<String, dynamic>> records,
      {bool exist = false}) {
    List<Map<String, dynamic>> seasonList = records.where((record) {
      return record['week'] == week && record['period'] == period;
    }).toList();
    return InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("${name}の科目"),
                content: Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                      itemCount: seasonList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            print(personalTimeTableList);
                          },
                          title: Text(seasonList[index]['授業名']),
                          trailing: personalTimeTableList
                                  .contains(seasonList[index]['lessonId'])
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                  ),
                                  onPressed: () {
                                    print(seasonList[index]['lessonId']);
                                  },
                                  child: const Text("削除する"))
                              : ElevatedButton(
                                  onPressed: () {
                                    print(seasonList[index]['lessonId']);
                                  },
                                  child: const Text("追加する")),
                        );
                      }),
                ),
              );
            },
          );
          //print(seasonList);
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          height: 100,
          decoration: BoxDecoration(
            border: exist ? Border.all(color: Colors.grey) : null,
            color: exist ? Colors.grey.shade300 : Colors.grey.shade100,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          padding: const EdgeInsets.all(3),
          child: Text(
            exist ? name : "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ));
  }

  Widget seasonTimeTableList(
      int seasonnumber, List<Map<String, dynamic>> records) {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.all(10.0),
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
          5: FlexColumnWidth(1),
          6: FlexColumnWidth(1),
        },
        children: <TableRow>[
          const TableRow(
            children: <Widget>[
              TableCell(
                  child: Center(
                      child: Text(
                "月",
                style: TextStyle(fontSize: 10),
              ))),
              TableCell(
                  child: Center(
                      child: Text(
                "火",
                style: TextStyle(fontSize: 10),
              ))),
              TableCell(
                  child: Center(
                      child: Text(
                "水",
                style: TextStyle(fontSize: 10),
              ))),
              TableCell(
                  child: Center(
                      child: Text(
                "木",
                style: TextStyle(fontSize: 10),
              ))),
              TableCell(
                  child: Center(
                      child: Text(
                "金",
                style: TextStyle(fontSize: 10),
              ))),
            ],
          ),
          TableRow(
            children: <Widget>[
              tableText("月曜1限", 1, 1, records, exist: true),
              tableText("火曜1限", 2, 1, records),
              tableText("水曜1限", 3, 1, records),
              tableText("木曜1限", 4, 1, records),
              tableText("金曜1限", 5, 1, records),
            ],
          ),
          TableRow(
            children: <Widget>[
              tableText("月曜2限", 1, 2, records),
              tableText("火曜2限", 2, 2, records),
              tableText("水曜2限", 3, 2, records),
              tableText("木曜2限", 4, 2, records),
              tableText("金曜2限", 5, 2, records),
            ],
          ),
          TableRow(
            children: <Widget>[
              tableText("月曜3限", 1, 3, records),
              tableText("火曜3限", 2, 3, records),
              tableText("水曜3限", 3, 3, records),
              tableText("木曜3限", 4, 3, records),
              tableText("金曜3限", 5, 3, records),
            ],
          ),
          TableRow(
            children: <Widget>[
              tableText("月曜4限", 1, 4, records),
              tableText("火曜4限", 2, 4, records),
              tableText("水曜4限", 3, 4, records),
              tableText("木曜4限", 4, 4, records),
              tableText("金曜4限", 5, 4, records),
            ],
          ),
          TableRow(
            children: <Widget>[
              tableText("月曜5限", 1, 5, records),
              tableText("火曜5限", 2, 5, records),
              tableText("水曜5限", 3, 5, records),
              tableText("木曜5限", 4, 5, records),
              tableText("金曜5限", 5, 5, records),
            ],
          ),
          TableRow(
            children: <Widget>[
              tableText("月曜6限", 1, 6, records),
              tableText("火曜6限", 2, 6, records),
              tableText("水曜6限", 3, 6, records),
              tableText("木曜6限", 4, 6, records),
              tableText("金曜6限", 5, 6, records),
            ],
          ),
        ],
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    loadPersonalTimeTableList();
    fetchRecords().then((value) {
      setState(() {
        records = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('時間割'),
        actions: [
          IconButton(
              onPressed: () {
                seasonTimeTable(records);
                //print(records);
              },
              icon: const Icon(Icons.abc))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: deviceHeight * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                2,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: Container(
                    width: deviceWidth * 0.3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: index == _currentPageIndex
                              ? customFunColor.shade400
                              : Colors.transparent, // 非選択時は透明
                          width: deviceWidth * 0.005,
                        ),
                      ),
                    ),
                    child: Text(
                      _getPageName(index),
                      style: TextStyle(
                        fontSize: deviceWidth / 25,
                        fontWeight: FontWeight.bold,
                        color: index == _currentPageIndex
                            ? customFunColor.shade400
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                seasonTimeTableList(10, records),
                seasonTimeTableList(20, records),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageName(int index) {
    switch (index) {
      case 0:
        return '前期';
      case 1:
        return '後期';
      default:
        return '';
    }
  }
}
