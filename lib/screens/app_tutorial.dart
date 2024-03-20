import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:dotto/components/color_fun.dart';

class AppTutorial extends StatelessWidget {
  const AppTutorial({super.key});

  Widget _withImage(double topMargin, String imagePath, String title,
      String body, Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Stack(children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: backgroundColor,
            image: DecorationImage(
              image: AssetImage(imagePath),
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          // ②Containerを重ねる
          child: Container(
            decoration: BoxDecoration(
              // ③グラデーション
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: const Alignment(0.0, 0.4),
                // ④透明→白
                colors: [
                  Colors.transparent,
                  backgroundColor,
                ],
              ),
            ),
          ),
        ),
        Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: topMargin),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  body,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            )),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topMargin = MediaQuery.of(context).size.height / 2;
    final Color backgroundColor = customFunColor.shade50;
    final pages = [
      PageModel.withChild(
        child: _withImage(
          topMargin,
          'assets/tutorial/home.png',
          'ホーム',
          '時間割を設定でき、休講・補講情報などの確認をできます',
          backgroundColor,
        ),
        color: backgroundColor,
      ),
      PageModel.withChild(
        child: _withImage(
          topMargin,
          'assets/tutorial/map.png',
          '学内マップ',
          '使用中の教室を確認したり、教員名で検索したりできます',
          backgroundColor,
        ),
        color: backgroundColor,
      ),
      PageModel.withChild(
        child: _withImage(
          topMargin,
          'assets/tutorial/kamoku.png',
          '科目検索',
          'シラバスから科目を検索できます',
          backgroundColor,
        ),
        color: backgroundColor,
      ),
      PageModel.withChild(
        child: _withImage(
          topMargin,
          'assets/tutorial/kadai.png',
          'HOPE課題',
          'HOPEで設定を行うことで課題を表示することができます',
          backgroundColor,
        ),
        color: backgroundColor,
      ),
      PageModel.withChild(
        child: const Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: Text(
              "さあ、始めましょう！",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            )),
        color: const Color(0xFFE0B3B3),
        doAnimateChild: true,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dottoの使い方'),
      ),
      body: OverBoard(
        buttonColor: Colors.black,
        activeBulletColor: Colors.black,
        inactiveBulletColor: Colors.black38,
        nextText: 'つぎへ',
        finishText: '閉じる',
        skipText: '閉じる',
        pages: pages,
        showBullets: true,
        skipCallback: () {
          // when user select SKIP
          Navigator.pop(context);
        },
        finishCallback: () {
          // when user select NEXT
          Navigator.pop(context);
        },
      ),
    );
  }
}
