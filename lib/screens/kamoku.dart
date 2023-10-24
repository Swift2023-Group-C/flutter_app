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
  var word = '';
  final TextEditingController _controller = TextEditingController();

  List<String> term = ['前期', '後期', '通年'];
  List<String> grade = ['1年', '2年', '3年', '4年', '教養'];
  List<String> courseStr = ['情シス', 'デザイン', '複雑', '知能', '高度ICT'];
  List<String> classification = ['必修', '選択'];
  List<String> education = ['社会', '人間', '科学', '健康', 'コミュ'];

  List<bool> termCheckedList = List.generate(3, (index) => false);
  List<bool> gradeCheckedList = List.generate(5, (index) => false);
  List<bool> courseStrCheckedList = List.generate(5, (index) => false);
  List<bool> classificationCheckedList = List.generate(2, (index) => false);
  List<bool> educationCheckedList = List.generate(5, (index) => false);

  bool allSelected = false;
  bool alltrue = true;
  bool allfalse = false;

  void searchClasses(String searchText, List<Map<String, dynamic>> records) {
    setState(() {
      _searchResults = records
          .where((record) => record['授業名'].toString().contains(searchText))
          .toList();
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
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 36,
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    hintText: '授業名を検索',
                  ),
                  onChanged: (text) {
                    word = text;
                  },
                ),
              ),
              Visibility(
                visible: isFiltersVisible,
                child: Column(
                  children: [
                    buildFilterRow(term, termCheckedList),
                    buildFilterRow(grade, gradeCheckedList),
                    buildFilterRow(courseStr, courseStrCheckedList),
                    buildFilterRow(classification, classificationCheckedList),
                    Visibility(
                      visible: gradeCheckedList[4],
                      child: buildFilterRow(education, educationCheckedList),
                    ),
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
              ElevatedButton(
                onPressed: () async {
                  List<Map<String, dynamic>> records = await search(
                      term: termCheckedList,
                      grade: gradeCheckedList.sublist(0, 4),
                      kyoyo: gradeCheckedList[4],
                      course: courseStrCheckedList,
                      classification: classificationCheckedList,
                      education: educationCheckedList);
                  searchClasses(word, records);
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
              _searchResults == null
                  ? Container()
                  : SearchResults(records: _searchResults!),
            ],
          ),
        ),
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
  /*チェックボックスが枠内に収まるバージョン
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
                  visualDensity: VisualDensity(
                    horizontal: -4, // チェックボックスの幅を小さく調整
                    vertical: -4, // チェックボックスの高さを小さく調整
                  ),
                ),
                Text(items[i]),
              ],
            ),
          const SizedBox(width: 20),
        ],
      ),
    ),
  );
}*/
}
