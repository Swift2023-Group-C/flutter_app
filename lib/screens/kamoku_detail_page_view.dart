import 'package:flutter/material.dart';
import 'package:flutter_app/screens/kamoku_detail_syllabus.dart';
import 'package:flutter_app/screens/kakomon_list.dart';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_app/screens/kamoku_detail_feedback.dart';

class KamokuDetailPageScreen extends StatefulWidget {
  const KamokuDetailPageScreen(
      {Key? key, required this.lessonId, required this.lessonName})
      : super(key: key);
  final int lessonId;
  final String lessonName;

  @override
  State<KamokuDetailPageScreen> createState() => _KamokuDetailPageScreenState();
}

class _KamokuDetailPageScreenState extends State<KamokuDetailPageScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonName),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50.0,
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
                    width: 120.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: index == _currentPageIndex
                              ? customFunColor.shade400
                              : Colors.transparent, // 非選択時は透明
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Text(
                      _getPageName(index),
                      style: TextStyle(
                        fontSize: 16.0,
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
                KakomonListScreen(url: widget.lessonId),
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
