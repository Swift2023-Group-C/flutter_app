import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
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
              children: const [
                SizedBox(
                  child: Center(
                    child: Text('項目1の内容', style: TextStyle(fontSize: 24.0)),
                  ),
                ),
                SizedBox(
                  child: Center(
                    child: Text('項目2の内容', style: TextStyle(fontSize: 24.0)),
                  ),
                ),
                SizedBox(
                  child: Center(
                    child: Text('項目3の内容', style: TextStyle(fontSize: 24.0)),
                  ),
                ),
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
        return '項目1';
      case 1:
        return '項目2';
      case 2:
        return '項目3';
      default:
        return '';
    }
  }
}
