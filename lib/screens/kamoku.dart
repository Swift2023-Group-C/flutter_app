import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/repository/kamoku_sort.dart';

class kamokusortScreen extends StatefulWidget {
  const kamokusortScreen({Key? key}) : super(key: key);

  @override
  _kamokusortScreenState createState() => _kamokusortScreenState();
}

class _kamokusortScreenState extends State<kamokusortScreen> {
  List<Map<String, dynamic>>? _searchResults;

  List<String> term = ['前期', '後期', '通年'];
  List<String> grade = ['1年', '2年', '3年', '4年', '教養', '専門'];
  List<String> courseStr = ['情シス', 'デザイン', '複雑', '知能', '高度ICT'];
  List<String> classification = ['選択', '必修'];
  List<String> education = ['社会', '人間', '科学', '健康', 'コミュ'];

  List<bool> term_checkedList = List.generate(3, (index) => false);
  List<bool> grade_checkedList = List.generate(6, (index) => false);
  List<bool> courseStr_checkedList = List.generate(5, (index) => false);
  List<bool> classification_checkedList = List.generate(2, (index) => false);
  List<bool> education_checkedList = List.generate(5, (index) => false);

  List<int> termlist = [];
  List<int> gradelist = [];
  List<int> courseStrlist = [];
  List<int> classlist = [];
  List<int> educationlist = [];

  bool allSelected = false;
  bool alltrue = true;
  bool allfalse = false;

  void searchClasses(String searchText) {
    fetchRecords().then((records) {
      setState(() {
        _searchResults = records
            .where((record) => record['授業名'].toString().contains(searchText))
            .toList();
      });
    });
  }

  void toggleAll() {
    setState(() {
      allSelected = !allSelected; // 全選択ボタンの状態を切り替える
      // boolListのすべての要素をallSelectedの値に合わせて設定
      term_checkedList =
          List.generate(term_checkedList.length, (index) => allSelected);
      grade_checkedList =
          List.generate(grade_checkedList.length, (index) => allSelected);
      courseStr_checkedList =
          List.generate(courseStr_checkedList.length, (index) => allSelected);
      classification_checkedList = List.generate(
          classification_checkedList.length, (index) => allSelected);
      education_checkedList =
          List.generate(education_checkedList.length, (index) => allSelected);
    });
  }

  void trueAll() {
    setState(() {
      // boolListのすべての要素をallSelectedの値に合わせて設定
      term_checkedList =
          List.generate(term_checkedList.length, (index) => alltrue);
      grade_checkedList =
          List.generate(grade_checkedList.length, (index) => alltrue);
      courseStr_checkedList =
          List.generate(courseStr_checkedList.length, (index) => alltrue);
      classification_checkedList =
          List.generate(classification_checkedList.length, (index) => alltrue);
      education_checkedList =
          List.generate(education_checkedList.length, (index) => alltrue);
    });
  }

  void falseAll() {
    setState(() {
      // boolListのすべての要素をallSelectedの値に合わせて設定
      term_checkedList =
          List.generate(term_checkedList.length, (index) => allfalse);
      grade_checkedList =
          List.generate(grade_checkedList.length, (index) => allfalse);
      courseStr_checkedList =
          List.generate(courseStr_checkedList.length, (index) => allfalse);
      classification_checkedList =
          List.generate(classification_checkedList.length, (index) => allfalse);
      education_checkedList =
          List.generate(education_checkedList.length, (index) => allfalse);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: SearchBox(
              onSearch: searchClasses,
            ),
          ),
          Container(
            //前期とか
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < term.length; i++)
                  Row(
                    children: [
                      Checkbox(
                        value: term_checkedList[i], // チェック状態を取得
                        onChanged: (bool? value) {
                          setState(() {
                            term_checkedList[i] = value ?? false; // チェック状態を更新
                          });
                          print(term_checkedList[i]);
                        },
                      ),
                      Text(term[i]),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            //学年
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < grade.length; i++)
                  Row(
                    children: [
                      Checkbox(
                        value: grade_checkedList[i], // チェック状態を取得
                        onChanged: (bool? value) {
                          setState(() {
                            grade_checkedList[i] = value ?? false; // チェック状態を更新
                          });
                          print(grade_checkedList[i]);
                        },
                      ),
                      Text(grade[i]),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            //コース
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < courseStr.length; i++)
                  Row(
                    children: [
                      Checkbox(
                        value: courseStr_checkedList[i], // チェック状態を取得
                        onChanged: (bool? value) {
                          setState(() {
                            courseStr_checkedList[i] =
                                value ?? false; // チェック状態を更新
                          });
                          print(courseStr_checkedList[i]);
                        },
                      ),
                      Text(courseStr[i]),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            //選択必修
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < classification.length; i++)
                  Row(
                    children: [
                      Checkbox(
                        value: classification_checkedList[i], // チェック状態を取得
                        onChanged: (bool? value) {
                          setState(() {
                            classification_checkedList[i] =
                                value ?? false; // チェック状態を更新
                          });
                          print(classification_checkedList[i]);
                        },
                      ),
                      Text(classification[i]),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            //教養
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < education.length; i++)
                  Row(
                    children: [
                      Checkbox(
                        value: education_checkedList[i], // チェック状態を取得
                        onChanged: (bool? value) {
                          setState(() {
                            education_checkedList[i] =
                                value ?? false; // チェック状態を更新
                          });
                          print(education_checkedList[i]);
                        },
                      ),
                      Text(education[i]),
                    ],
                  ),
              ],
            ),
          ),
          Text('とりまいろんなボタン作った'),
          Container(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // ボタンをクリックしたら全選択状態を切り替える
                    toggleAll();
                  },
                  child: Text(allSelected ? 'すべて解除' : 'すべて選択'),
                ),
                TextButton(
                    onPressed: () {
                      trueAll();
                    },
                    child: Text('全選択')),
                TextButton(
                    onPressed: () {
                      falseAll();
                    },
                    child: Text('リセット')),
                TextButton(
                    onPressed: () async {
                      termlist.clear();
                      gradelist.clear();
                      courseStrlist.clear();
                      classlist.clear();
                      educationlist.clear();
                      for (int i = 0; i < term.length; i++) {
                        if (term_checkedList[i] == true) {
                          termlist.add(i);
                        }
                      }
                      for (int i = 0; i < grade.length; i++) {
                        if (grade_checkedList[i] == true) {
                          gradelist.add(i);
                        }
                      }
                      for (int i = 0; i < courseStr.length; i++) {
                        if (courseStr_checkedList[i] == true) {
                          courseStrlist.add(i);
                        }
                      }
                      for (int i = 0; i < classification.length; i++) {
                        if (classification_checkedList[i] == true) {
                          classlist.add(i);
                        }
                      }
                      for (int i = 0; i < education.length; i++) {
                        if (education_checkedList[i] == true) {
                          educationlist.add(i);
                        }
                      }
                      List<Map<String, dynamic>> records = await search(
                          term: termlist,
                          grade: gradelist,
                          courseStr: courseStrlist,
                          classification: classlist,
                          education: educationlist);
                      //print(records);
                      setState(() {
                        _searchResults = records;
                      });
                      print(termlist);
                      print(gradelist);
                      print(courseStrlist);
                      print(classlist);
                      print(educationlist);
                    },
                    child: Text('絞り込み')),
              ],
            ),
          ),
          Text('結果一覧'),
          Expanded(
            //よくわからんけどこれがあると授業名検索結果が表示される
            child: _searchResults == null
                ? Container()
                : SearchResults(records: _searchResults!),
          ),
        ],
      ),
    );
  }
}
