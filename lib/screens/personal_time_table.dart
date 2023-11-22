import 'package:flutter/material.dart';
import 'package:flutter_app/components/db_config.dart';
import 'package:flutter_app/components/setting_user_info.dart';
import 'dart:convert';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_app/repository/narrowed_lessons.dart';
import 'package:sqflite/sqflite.dart';

class PersonalTimeTableScreen extends StatefulWidget {
  const PersonalTimeTableScreen({Key? key}) : super(key: key);

  @override
  State<PersonalTimeTableScreen> createState() =>
      _PersonalTimeTableScreenState();
}

class _PersonalTimeTableScreenState extends State<PersonalTimeTableScreen> {
  List<int> personalTimeTableList = [];
  List<dynamic> filteredData = [];
  late List<Map<String, dynamic>> records = [];
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  // Future<void> loadPersonalTimeTableList() async {
  //   final jsonString = await UserPreferences.getFinishList();
  //   if (jsonString != null) {
  //     setState(() {
  //       personalTimeTableList = List<int>.from(json.decode(jsonString));
  //       //print(personalTimeTableList);
  //     });
  //   }
  // }

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

  Widget seasonTimeTableList(
      int seasonnumber, List<Map<String, dynamic>> records) {
    List<Map<String, dynamic>> seasonList = records.where((record) {
      return record['開講時期'] == seasonnumber;
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
  }

  @override
  void initState() {
    super.initState();
    loadPersonalTimeTableList();
    filterTimeTable();
    fetchRecords().then((value) {
      setState(() {
        records = value;
      });
    });
  }

  // Future<void> fetchFilteredData() async {
  //   filteredData = await filterTimeTable(personalTimeTableList);
  //   print(filteredData);
  // }

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
                3,
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
                seasonTimeTableList(0, records),
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
      case 2:
        return '通年';
      default:
        return '';
    }
  }
}
