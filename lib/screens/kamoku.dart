import 'package:flutter/material.dart';
import 'package:flutter_app/repository/kamoku_sort.dart';

class KamokuSearchScreen extends StatefulWidget {
  const KamokuSearchScreen({Key? key}) : super(key: key);

  @override
  State<KamokuSearchScreen> createState() => _KamokuSearchScreenState();
}

class _KamokuSearchScreenState extends State<KamokuSearchScreen> {
  bool isFiltersVisible = true;
  List<Map<String, dynamic>>? _searchResults;

  List<String> term = ['前期', '後期', '通年'];
  List<String> grade = ['1年', '2年', '3年', '4年', '教養', '専門'];
  List<String> courseStr = ['情シス', 'デザイン', '複雑', '知能', '高度ICT'];
  List<String> classification = ['選択', '必修'];
  List<String> education = ['社会', '人間', '科学', '健康', 'コミュ'];

  List<bool> termCheckedList = List.generate(3, (index) => false);
  List<bool> gradeCheckedList = List.generate(6, (index) => false);
  List<bool> courseStrCheckedList = List.generate(5, (index) => false);
  List<bool> classificationCheckedList = List.generate(2, (index) => false);
  List<bool> educationCheckedList = List.generate(5, (index) => false);

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
      termCheckedList =
          List.generate(termCheckedList.length, (index) => allSelected);
      gradeCheckedList =
          List.generate(gradeCheckedList.length, (index) => allSelected);
      courseStrCheckedList =
          List.generate(courseStrCheckedList.length, (index) => allSelected);
      classificationCheckedList = List.generate(
          classificationCheckedList.length, (index) => allSelected);
      educationCheckedList =
          List.generate(educationCheckedList.length, (index) => allSelected);
    });
  }

  void trueAll() {
    setState(() {
      // boolListのすべての要素をallSelectedの値に合わせて設定
      termCheckedList =
          List.generate(termCheckedList.length, (index) => alltrue);
      gradeCheckedList =
          List.generate(gradeCheckedList.length, (index) => alltrue);
      courseStrCheckedList =
          List.generate(courseStrCheckedList.length, (index) => alltrue);
      classificationCheckedList =
          List.generate(classificationCheckedList.length, (index) => alltrue);
      educationCheckedList =
          List.generate(educationCheckedList.length, (index) => alltrue);
    });
  }

  void falseAll() {
    setState(() {
      // boolListのすべての要素をallSelectedの値に合わせて設定
      termCheckedList =
          List.generate(termCheckedList.length, (index) => allfalse);
      gradeCheckedList =
          List.generate(gradeCheckedList.length, (index) => allfalse);
      courseStrCheckedList =
          List.generate(courseStrCheckedList.length, (index) => allfalse);
      classificationCheckedList =
          List.generate(classificationCheckedList.length, (index) => allfalse);
      educationCheckedList =
          List.generate(educationCheckedList.length, (index) => allfalse);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchBox(
            onSearch: searchClasses,
          ),
          Visibility(
            visible: isFiltersVisible,
            child: Column(
              children: [
                buildFilterRow(term, termCheckedList),
                buildFilterRow(grade, gradeCheckedList),
                buildFilterRow(courseStr, courseStrCheckedList),
                buildFilterRow(classification, classificationCheckedList),
                buildFilterRow(education, educationCheckedList),
                Row(children: [
                  TextButton(
                      onPressed: () {
                        trueAll();
                      },
                      child: const Text('全選択')),
                  TextButton(
                      onPressed: () {
                        falseAll();
                      },
                      child: const Text('リセット')),
                ])
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isFiltersVisible = !isFiltersVisible;
              });
            },
            child: Icon(
              isFiltersVisible ? Icons.expand_less : Icons.expand_more,
            ),
          ),
          // Align(
          //   alignment: const AlignmentDirectional(-1.00, 0.00),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         for (int i = 0; i < term.length; i++)
          //           Row(
          //             children: [
          //               Checkbox(
          //                 value: termCheckedList[i], // チェック状態を取得
          //                 onChanged: (bool? value) {
          //                   setState(() {
          //                     termCheckedList[i] = value ?? false; // チェック状態を更新
          //                   });
          //                 },
          //               ),
          //               Text(term[i]),
          //             ],
          //           ),
          //         const SizedBox(width: 20),
          //       ],
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: const AlignmentDirectional(-1.00, 0.00),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          //       for (int i = 0; i < grade.length; i++)
          //         Row(
          //           children: [
          //             Checkbox(
          //               value: gradeCheckedList[i], // チェック状態を取得
          //               onChanged: (bool? value) {
          //                 setState(() {
          //                   gradeCheckedList[i] = value ?? false; // チェック状態を更新
          //                 });
          //               },
          //             ),
          //             Text(grade[i]),
          //           ],
          //         ),
          //       const SizedBox(width: 20),
          //     ]),
          //   ),
          // ),
          // Align(
          //   alignment: const AlignmentDirectional(-1.00, 0.00),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         for (int i = 0; i < courseStr.length; i++)
          //           Row(
          //             children: [
          //               Checkbox(
          //                 value: courseStrCheckedList[i], // チェック状態を取得
          //                 onChanged: (bool? value) {
          //                   setState(() {
          //                     courseStrCheckedList[i] =
          //                         value ?? false; // チェック状態を更新
          //                   });
          //                 },
          //               ),
          //               Text(courseStr[i]),
          //             ],
          //           ),
          //         const SizedBox(width: 20),
          //       ],
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: const AlignmentDirectional(-1.00, 0.00),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         for (int i = 0; i < classification.length; i++)
          //           Row(
          //             children: [
          //               Checkbox(
          //                 value: classificationCheckedList[i], // チェック状態を取得
          //                 onChanged: (bool? value) {
          //                   setState(() {
          //                     classificationCheckedList[i] =
          //                         value ?? false; // チェック状態を更新
          //                   });
          //                 },
          //               ),
          //               Text(classification[i]),
          //             ],
          //           ),
          //         const SizedBox(width: 20),
          //       ],
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: const AlignmentDirectional(-1.00, 0.00),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         for (int i = 0; i < education.length; i++)
          //           Row(
          //             children: [
          //               Checkbox(
          //                 value: educationCheckedList[i], // チェック状態を取得
          //                 onChanged: (bool? value) {
          //                   setState(() {
          //                     educationCheckedList[i] =
          //                         value ?? false; // チェック状態を更新
          //                   });
          //                 },
          //               ),
          //               Text(education[i]),
          //             ],
          //           ),
          //         const SizedBox(width: 20),
          //       ],
          //     ),
          //   ),
          // ),
          // TextButton(
          //   onPressed: () {
          //     // ボタンをクリックしたら全選択状態を切り替える
          //     toggleAll();
          //   },
          //   child: Text(allSelected ? 'すべて解除' : 'すべて選択'),
          // ),
          // TextButton(
          //     onPressed: () {
          //       trueAll();
          //     },
          //     child: const Text('全選択')),
          // TextButton(
          //     onPressed: () {
          //       falseAll();
          //     },
          //     child: const Text('リセット')),
          ElevatedButton(
            onPressed: () async {
              termlist.clear();
              gradelist.clear();
              courseStrlist.clear();
              classlist.clear();
              educationlist.clear();
              for (int i = 0; i < term.length; i++) {
                if (termCheckedList[i] == true) {
                  termlist.add(i);
                }
              }
              for (int i = 0; i < grade.length; i++) {
                if (gradeCheckedList[i] == true) {
                  gradelist.add(i);
                }
              }
              for (int i = 0; i < courseStr.length; i++) {
                if (courseStrCheckedList[i] == true) {
                  courseStrlist.add(i);
                }
              }
              for (int i = 0; i < classification.length; i++) {
                if (classificationCheckedList[i] == true) {
                  classlist.add(i);
                }
              }
              for (int i = 0; i < education.length; i++) {
                if (educationCheckedList[i] == true) {
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
            },
            child: const Text(
              '検索の実行',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
          ),
          const Text(
            '結果一覧',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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

  Widget buildFilterRow(List<String> items, List<bool> checkedList) {
    return Align(
      alignment: const AlignmentDirectional(-1.00, 0.00),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = 0; i < items.length; i++)
              Row(
                children: [
                  Checkbox(
                    value: checkedList[i],
                    onChanged: (bool? value) {
                      setState(() {
                        checkedList[i] = value ?? false;
                      });
                    },
                  ),
                  Text(items[i]),
                ],
              ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
