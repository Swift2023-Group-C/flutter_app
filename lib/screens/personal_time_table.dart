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

    String whereClause = personalTimeTableList.map((id) => '?').join(', ');
    List<Map<String, dynamic>> records = await database.query(
      'week_period',
      where: 'lessonID IN ($whereClause)',
      whereArgs: personalTimeTableList,
    );
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

  InkWell tableText(
      String name, int week, period, List<Map<String, dynamic>> records,
      {bool exist = false}) {
    List<Map<String, dynamic>> seasonList = records.where((record) {
      return record['week'] == week && record['period'] == period;
    }).toList();
    return InkWell(
        onTap: () {
          print(seasonList);
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
              tableText("オペレーションズリサーチ2-ABCD", 1, 1, records),
              tableText("Cell(1,2)", 2, 1, records),
              tableText("Cell(1,3)", 3, 1, records),
              tableText("Cell(1,4)", 4, 1, records),
              tableText("Cell(1,5)", 5, 1, records),
            ],
          ),
          TableRow(
            children: <Widget>[
              tableText("Cell(2,1)", 1, 2, records),
              tableText("Cell(2,2)", 2, 2, records),
              tableText("Cell(2,3)", 3, 2, records),
              tableText("Cell(2,4)", 4, 2, records),
              tableText("Cell(2,5)", 5, 2, records),
            ],
          ),
          TableRow(
            children: <Widget>[
              tableText("Cell(3,1)", 1, 3, records),
              tableText("Cell(3,2)", 2, 3, records),
              tableText("Cell(3,3)", 3, 3, records),
              tableText("Cell(3,4)", 4, 3, records),
              tableText("Cell(3,5)", 5, 3, records),
            ],
          ),
          TableRow(
            children: <Widget>[
              tableText("Cell(4,1)", 1, 4, records),
              tableText("Cell(4,2)", 2, 4, records),
              tableText("Cell(4,3)", 3, 4, records),
              tableText("Cell(4,4)", 4, 4, records),
              tableText("Cell(4,5)", 5, 4, records),
            ],
          ),
          TableRow(
            children: <Widget>[
              tableText("Cell(5,1)", 1, 5, records),
              tableText("Cell(5,2)", 2, 5, records),
              tableText("Cell(5,3)", 3, 5, records),
              tableText("Cell(5,4)", 4, 5, records),
              tableText("Cell(5,5)", 5, 5, records),
            ],
          ),
          TableRow(
            children: <Widget>[
              tableText("Cell(6,1)", 1, 6, records),
              tableText("Cell(6,2)", 2, 6, records),
              tableText("Cell(6,3)", 3, 6, records),
              tableText("Cell(6,4)", 4, 6, records),
              tableText("Cell(6,5)", 5, 6, records),
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
