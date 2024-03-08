import 'package:dotto/components/color_fun.dart';
import 'package:flutter/material.dart';
import 'package:dotto/repository/kamoku_sort.dart';
import 'package:dotto/components/setting_user_info.dart';

class KamokuSearchScreen extends StatefulWidget {
  const KamokuSearchScreen({Key? key}) : super(key: key);

  @override
  State<KamokuSearchScreen> createState() => _KamokuSearchScreenState();
}

class _KamokuSearchScreenState extends State<KamokuSearchScreen> {
  List<Map<String, dynamic>>? _searchResults;
  var word = '';
  final TextEditingController _controller = TextEditingController();

  Future<void> updateGradeCheckedList() async {
    String? savedGrade =
        await UserPreferences.getString(UserPreferenceKeys.grade);

    if (savedGrade != null) {
      int? index = grade.indexOf(savedGrade);
      if (index != -1 && index < gradeCheckedList.length) {
        setState(() {
          gradeCheckedList[index] = true;
        });
      }
    }
  }

  Future<void> updateCourseStrCheckedList() async {
    String? savedCourse =
        await UserPreferences.getString(UserPreferenceKeys.course);

    if (savedCourse != null) {
      int? index = courseStr.indexOf(savedCourse);
      if (index != -1 && index < courseStrCheckedList.length) {
        setState(() {
          courseStrCheckedList[index] = true;
        });
      }
    }
  }

  List<String> term = ['前期', '後期', '通年'];
  List<String> senmonKyoyo = ['専門', '教養'];
  List<String> grade = ['1年', '2年', '3年', '4年'];
  List<String> courseStr = ['情報システム', '情報デザイン', '複雑', '知能', '高度ICT'];
  List<String> coursedisplayStr = ['情シス', '情デザ', '複雑', '知能', '高度ICT'];
  List<String> classification = ['必修', '選択'];
  List<String> education = ['社会', '人間', '科学', '健康', 'コミュ'];

  List<bool> termCheckedList = List.generate(3, (index) => false);
  List<bool> gradeCheckedList = List.generate(4, (index) => false);
  List<bool> courseStrCheckedList = List.generate(5, (index) => false);
  List<bool> classificationCheckedList = List.generate(2, (index) => false);
  List<bool> educationCheckedList = List.generate(5, (index) => false);

  int senmonKyoyoStatus = -1;

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

  void falseAll() {
    setState(() {
      senmonKyoyoStatus = -1;
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

  bool classificationStatus() {
    return !gradeCheckedList.every((element) => !element) ||
        !courseStrCheckedList.every((element) => !element);
  }

  @override
  void initState() {
    super.initState();

    // 保存されたgradeとcourseの値に基づいてチェックリストを更新
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await updateGradeCheckedList();
      await updateCourseStrCheckedList();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    hintText: '科目名を検索',
                  ),
                  onChanged: (text) {
                    word = text;
                  },
                ),
              ),
              Column(
                children: [
                  buildFilterRow(term, termCheckedList),
                  buildFilterRadioRow(),
                  Visibility(
                    visible: senmonKyoyoStatus == 0,
                    child: buildFilterRow(grade, gradeCheckedList),
                  ),
                  Visibility(
                    visible: senmonKyoyoStatus == 0,
                    child:
                        buildFilterRow(coursedisplayStr, courseStrCheckedList),
                  ),
                  Visibility(
                    visible: classificationStatus(),
                    child: buildFilterRow(
                        classification, classificationCheckedList),
                  ),
                  Visibility(
                    visible: senmonKyoyoStatus == 1,
                    child: buildFilterRow(education, educationCheckedList),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextButton(
                        onPressed: () {
                          falseAll();
                          _controller.clear();
                          word = '';
                        },
                        child: const Text('リセット')),
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customFunColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          List<Map<String, dynamic>> records = await search(
                              term: termCheckedList,
                              senmon: senmonKyoyoStatus,
                              grade: gradeCheckedList,
                              course: courseStrCheckedList,
                              classification: classificationCheckedList,
                              education: educationCheckedList);
                          searchClasses(word, records);
                        },
                        child: const SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '科目検索',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Icon(
                                  Icons.search,
                                )
                              ],
                            ))),
                  ),
                ],
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Text(
                        '結果一覧',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ))),
              if (_searchResults != null)
                if (_searchResults!.isNotEmpty)
                  SearchResults(records: _searchResults!)
                else
                  const Center(
                    child: Text('検索結果は見つかりませんでした'),
                  ),
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
              SizedBox(
                width: 100,
                child: Row(
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
              ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget buildFilterRadioRow() {
    return Align(
      alignment: const AlignmentDirectional(-1.00, 0.00),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = 0; i < senmonKyoyo.length; i++)
              SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Radio(
                      value: i,
                      onChanged: (value) {
                        setState(() {
                          senmonKyoyoStatus = value ?? -1;
                        });
                      },
                      groupValue: senmonKyoyoStatus,
                    ),
                    Text(senmonKyoyo[i]),
                  ],
                ),
              ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
