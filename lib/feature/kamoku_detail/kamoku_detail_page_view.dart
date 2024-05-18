import 'package:dotto/importer.dart';

import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/kamoku_detail/kamoku_detail_syllabus.dart';
import 'package:dotto/feature/kamoku_detail/kamoku_detail_kakomon_list.dart';
import 'package:dotto/feature/kamoku_detail/kamoku_detail_feedback.dart';

class KamokuDetailPageScreen extends StatefulWidget {
  const KamokuDetailPageScreen(
      {super.key,
      required this.lessonId,
      required this.lessonName,
      this.kakomonLessonId});
  final int lessonId;
  final String lessonName;
  final int? kakomonLessonId;

  @override
  State<KamokuDetailPageScreen> createState() => _KamokuDetailPageScreenState();
}

class _KamokuDetailPageScreenState extends State<KamokuDetailPageScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  bool appBarText = false;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child:
              Text(appBarText ? widget.lessonId.toString() : widget.lessonName),
          onDoubleTap: () {
            setState(() {
              appBarText = !appBarText;
            });
          },
        ),
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
                KamokuDetailSyllabusScreen(lessonId: widget.lessonId),
                KamokuFeedbackScreen(lessonId: widget.lessonId),
                KamokuDetailKakomonListScreen(
                    url: widget.kakomonLessonId ?? widget.lessonId),
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
        return 'シラバス';
      case 1:
        return 'レビュー';
      case 2:
        return '過去問';
      default:
        return '';
    }
  }
}
