import 'package:flutter/material.dart';
import 'setting_user_info.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

/* リストで簡潔に書けると思う
const List<String> grade = <String>['1年', '2年', '3年', '4年'];
const List<String> course = <String>[
  'なし',
  '情報システム',
  '情報デザイン',
  '知能',
  '複雑',
  '高度ICT'
];
*/

class _SettingScreenState extends State<SettingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  final TextEditingController _userKeyController = TextEditingController();

  // 2つのプルダウンの初期値を設定
  String dropdownValue1 = 'なし';
  String dropdownValue2 = 'なし';

  @override
  void dispose() {
    _userKeyController.dispose(); // リソースの解放
    super.dispose();
  }

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
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<String>(
                        value: dropdownValue1,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue1 = newValue!;
                          });
                        },
                        items: <String>['なし', '1年', '2年', '3年', '4年']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue2,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue2 = newValue!;
                          });
                        },
                        items: <String>[
                          'なし',
                          '情報システム',
                          '情報デザイン',
                          '知能',
                          '複雑',
                          '高度ICT'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _userKeyController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'ユーザーキー',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _saveSettings,
                        child: const Text("設定保存"),
                      ),
                      ElevatedButton(
                        onPressed: _checkSettings,
                        child: const Text("保存設定を確認"),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  child: Center(
                    child: Text('項目2の内容', style: TextStyle(fontSize: 24.0)),
                  ),
                ),
                const SizedBox(
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

  // 設定保存処理
  _saveSettings() async {
    await UserPreferences.setGrade(dropdownValue1);
    await UserPreferences.setCourse(dropdownValue2);
    await UserPreferences.setUserKey(_userKeyController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('設定が保存されました。')),
    );
  }

//保存設定を確認する処理
  _checkSettings() async {
    String? grade = await UserPreferences.getGrade();
    String? course = await UserPreferences.getCourse();
    String? userKey = await UserPreferences.getUserKey();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('保存された設定'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Grade: $grade'),
                Text('Course: $course'),
                Text('User Key: $userKey'),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('閉じる'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
