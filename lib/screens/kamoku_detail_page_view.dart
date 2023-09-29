import 'package:flutter/material.dart';
import 'kamoku_detail_syllabus.dart';
import 'kakomon_list.dart';

class KamokuDetailPageScreen extends StatefulWidget {
  const KamokuDetailPageScreen({Key? key, required this.lessonId})
      : super(key: key);
  final int lessonId;

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
        title: Text(widget.lessonId.toString()),
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
                    width: 100.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: index == _currentPageIndex
                              ? const Color.fromARGB(255, 125, 29, 29)
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
                            ? const Color.fromARGB(255, 125, 29, 29)
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
                const SizedBox(
                  child: Center(
                    child: Text('Feedback', style: TextStyle(fontSize: 24.0)),
                  ),
                ),
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
        return 'フィードバック';
      case 2:
        return '過去問';
      default:
        return '';
    }
  }
}
