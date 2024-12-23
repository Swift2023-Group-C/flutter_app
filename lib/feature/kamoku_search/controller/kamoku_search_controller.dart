import 'package:sqflite/sqflite.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:dotto/importer.dart';
import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/repository/db_config.dart';
import 'package:dotto/feature/kamoku_search/domain/kamoku_search_choices.dart';

part 'kamoku_search_controller.freezed.dart';

final kamokuSearchControllerProvider =
    StateNotifierProvider<KamokuSearchControllerProvider, KamokuSearchController>(
        (ref) => KamokuSearchControllerProvider());

@freezed
class KamokuSearchController with _$KamokuSearchController {
  const factory KamokuSearchController({
    required int senmonKyoyoStatus,
    required Map<KamokuSearchChoices, List<bool>> checkboxStatusMap,
    @Default({KamokuSearchChoices.term}) Set<KamokuSearchChoices> visibilityStatus,
    required List<Map<String, dynamic>>? searchResults,
    required TextEditingController textEditingController,
    required FocusNode searchBoxFocusNode,
    @Default("") String searchWord,
  }) = _KamokuSearchController;
}

class KamokuSearchControllerProvider extends StateNotifier<KamokuSearchController> {
  KamokuSearchControllerProvider()
      : super(KamokuSearchController(
          senmonKyoyoStatus: -1,
          checkboxStatusMap: Map.fromIterables(KamokuSearchChoices.values,
              KamokuSearchChoices.values.map((e) => List.filled(e.choice.length, false))),
          searchResults: null,
          textEditingController: TextEditingController(),
          searchBoxFocusNode: FocusNode(),
        )) {
    Future(
      () async {
        await updateCheckListFromPreferences();
      },
    );
  }

  Future<void> updateCheckListFromPreferences() async {
    String? savedGrade = await UserPreferences.getString(UserPreferenceKeys.grade);
    String? savedCourse = await UserPreferences.getString(UserPreferenceKeys.course);
    Map<KamokuSearchChoices, List<bool>> checkboxStatusMap = state.checkboxStatusMap;
    if (savedGrade != null) {
      int? index = KamokuSearchChoices.grade.choice.indexOf(savedGrade);
      if (index != -1 && index < checkboxStatusMap[KamokuSearchChoices.grade]!.length) {
        checkboxStatusMap[KamokuSearchChoices.grade]![index] = true;
      }
    }
    if (savedCourse != null) {
      int? index = KamokuSearchChoices.course.choice.indexOf(savedCourse);
      if (index != -1 && index < checkboxStatusMap[KamokuSearchChoices.course]!.length) {
        checkboxStatusMap[KamokuSearchChoices.course]![index] = true;
      }
    }
    state = state.copyWith(checkboxStatusMap: checkboxStatusMap);
  }

  // Radioボタン Text
  final List<String> checkboxSenmonKyoyo = ['専門', '教養', '大学院'];

  void reset() {
    Map<KamokuSearchChoices, List<bool>> checkboxStatusMap = Map.fromIterables(
        KamokuSearchChoices.values,
        KamokuSearchChoices.values.map((e) => List.filled(e.choice.length, false)));
    Set<KamokuSearchChoices> visibilityStatus = {KamokuSearchChoices.term};
    String searchWord = "";
    state.textEditingController.clear();
    state = state.copyWith(
      senmonKyoyoStatus: -1,
      checkboxStatusMap: checkboxStatusMap,
      visibilityStatus: visibilityStatus,
      searchWord: searchWord,
    );
  }

  void setSearchWord(String word) {
    state = state.copyWith(searchWord: word);
  }

  void checkboxOnChanged(bool? value, KamokuSearchChoices kamokuSearchChoices, int index) {
    Map<KamokuSearchChoices, List<bool>> checkboxStatusMap = state.checkboxStatusMap;
    checkboxStatusMap[kamokuSearchChoices]![index] = value ?? false;
    if (kamokuSearchChoices == KamokuSearchChoices.grade &&
        index > 0 &&
        checkboxStatusMap[KamokuSearchChoices.grade]![0]) {
      checkboxStatusMap[KamokuSearchChoices.grade]![0] = false;
    }
    if (checkboxStatusMap[KamokuSearchChoices.grade]!.any((element) => element)) {
      if (checkboxStatusMap[KamokuSearchChoices.grade]![0]) {
        for (var i = 1; i < checkboxStatusMap[KamokuSearchChoices.grade]!.length; i++) {
          checkboxStatusMap[KamokuSearchChoices.grade]![i] = false;
        }
      }
    }
    state = state.copyWith(
      checkboxStatusMap: checkboxStatusMap,
      visibilityStatus: setVisibilityStatus(checkboxStatusMap, state.senmonKyoyoStatus),
    );
  }

  // Radioボタンが押されたときの処理
  void radioOnChanged(int? value) {
    int senmonKyoyoStatus = value ?? -1;
    state = state.copyWith(
      senmonKyoyoStatus: senmonKyoyoStatus,
      visibilityStatus: setVisibilityStatus(state.checkboxStatusMap, senmonKyoyoStatus),
    );
  }

  // Radioボタンが押されたときの処理 2
  Set<KamokuSearchChoices> setVisibilityStatus(
      Map<KamokuSearchChoices, List<bool>> checkboxStatusMap, int senmonKyoyoStatus) {
    Set<KamokuSearchChoices> visibilityStatus = state.visibilityStatus;
    if (senmonKyoyoStatus == 0) {
      // 専門
      visibilityStatus = {
        KamokuSearchChoices.term,
        KamokuSearchChoices.grade,
      };
      if (checkboxStatusMap[KamokuSearchChoices.grade]!.any((element) => element) ||
          checkboxStatusMap[KamokuSearchChoices.course]!.any((element) => element)) {
        visibilityStatus.add(KamokuSearchChoices.classification);
        if (!checkboxStatusMap[KamokuSearchChoices.grade]![0]) {
          visibilityStatus.add(KamokuSearchChoices.course);
        }
      } else {
        visibilityStatus.remove(KamokuSearchChoices.classification);
      }
    } else if (senmonKyoyoStatus == 1) {
      // 教養
      visibilityStatus = {
        KamokuSearchChoices.term,
        KamokuSearchChoices.education,
        KamokuSearchChoices.classification
      };
    } else if (senmonKyoyoStatus == 2) {
      // 大学院
      visibilityStatus = {
        KamokuSearchChoices.term,
        KamokuSearchChoices.masterField,
      };
    }
    return visibilityStatus;
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

  // 科目検索ボタンが押されたときの処理
  Future<void> search() async {
    Database database = await openDatabase(SyllabusDBConfig.dbPath);
    List<String> sqlWhereList = [];
    List<String> sqlWhereListKyoyo = [];
    String sqlWhere = "";

    final List<bool> termCheckList = state.checkboxStatusMap[KamokuSearchChoices.term] ?? [];
    final List<bool> gradeCheckList = state.checkboxStatusMap[KamokuSearchChoices.grade] ?? [];
    final List<bool> courseCheckList = state.checkboxStatusMap[KamokuSearchChoices.course] ?? [];
    final List<bool> classificationCheckList =
        state.checkboxStatusMap[KamokuSearchChoices.classification] ?? [];
    final List<bool> educationCheckList =
        state.checkboxStatusMap[KamokuSearchChoices.education] ?? [];
    final List<bool> masterFieldCheckList =
        state.checkboxStatusMap[KamokuSearchChoices.masterField] ?? [];

    // 開講時期
    // ['前期', '後期', '通年']
    List<String> sqlWhereTerm = [];
    if (isNotAllTrueOrAllFalse(termCheckList)) {
      List<String> termName = ['10', '20', '0'];
      for (var i = 0; i < termCheckList.length; i++) {
        if (termCheckList[i]) {
          sqlWhereTerm.add(termName[i]);
        }
      }
      sqlWhereList.add("(sort.開講時期 IN (${sqlWhereTerm.join(", ")}))");
    }

    // 専門・教養・大学院の分岐
    if (state.senmonKyoyoStatus == 0) {
      // 学年
      // ['1年', '2年', '3年', '4年']
      if (isNotAllTrueOrAllFalse(gradeCheckList)) {
        List<String> sqlWhereGrade = [];
        List<String> gradeName = ['一年次', '二年次', '三年次', '四年次'];
        for (var i = 0; i < gradeCheckList.length; i++) {
          if (gradeCheckList[i]) {
            sqlWhereGrade.add("sort.${gradeName[i]}=1");
          }
        }
        sqlWhereList.add("(${sqlWhereGrade.join(" OR ")})");
        final List<String> classificationName = ["100", "101"];
        if (gradeCheckList[0]) {
          // 1年
          // ['必修', '選択']
          if (isNotAllTrueOrAllFalse(classificationCheckList)) {
            for (int j = 0; j < classificationCheckList.length; j++) {
              if (classificationCheckList[j]) {
                sqlWhereList.add("(sort.一年コース=${classificationName[j]})");
              }
            }
          }
        } else {
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

          if (isNotAllTrueOrAllFalse(courseCheckList)) {
            for (int i = 0; i < courseCheckList.length; i++) {
              if (courseCheckList[i]) {
                if (isNotAllTrueOrAllFalse(classificationCheckList)) {
                  for (int j = 0; j < classificationCheckList.length; j++) {
                    if (classificationCheckList[j]) {
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
        }
      }
    } else if (state.senmonKyoyoStatus == 1) {
      // 教養
      List<String> sqlWhereKyoyo = [];
      sqlWhereListKyoyo.add("(sort.教養!=0)");
      if (isNotAllTrueOrAllFalse(educationCheckList)) {
        List<String> educationNo = ['2', '1', '3', '4', '5'];
        for (var i = 0; i < educationCheckList.length; i++) {
          if (educationCheckList[i]) {
            sqlWhereKyoyo.add("sort.教養=${educationNo[i]}");
          }
        }
        sqlWhereListKyoyo.add("(${sqlWhereKyoyo.join(" OR ")})");
      }
      if (isNotAllTrueOrAllFalse(classificationCheckList)) {
        if (classificationCheckList[0]) {
          sqlWhereListKyoyo.add("(sort.教養必修=1)");
        }
        if (classificationCheckList[1]) {
          sqlWhereListKyoyo.add("(sort.教養必修!=1)");
        }
      }
      sqlWhereList.add("(${sqlWhereListKyoyo.join(" AND ")})");
    } else if (state.senmonKyoyoStatus == 2) {
      sqlWhereList.add("(sort.LessonId LIKE '5_____')");
      int masterFieldInt = 0;
      for (var i = 0; i < masterFieldCheckList.length; i++) {
        if (masterFieldCheckList[i]) {
          masterFieldInt |= 1 << masterFieldCheckList.length - i - 1;
        }
      }
      if (masterFieldInt == 0) {
        masterFieldInt = 63;
      }
      sqlWhereList.add("(sort.大学院 & ${masterFieldInt.toString()})");
    }

    if (sqlWhereList.isNotEmpty) {
      sqlWhere = sqlWhereList.join(" AND ");
    }

    debugPrint(sqlWhere);
    List<Map<String, dynamic>> records;
    sqlWhere = (sqlWhere == "") ? "1" : sqlWhere;
    records = await database.rawQuery(
        'SELECT * FROM sort detail INNER JOIN sort ON sort.LessonId=detail.LessonId WHERE $sqlWhere');
    state = state.copyWith(
        searchResults: records
            .where((record) => record['授業名'].toString().contains(state.searchWord))
            .toList());
  }
}
