import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';

class AppTutorial extends StatelessWidget {
  const AppTutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = [
      /*
      PageModel(
          color: const Color(0xFFE0B3B3),
          imageAssetPath: 'assets/0.png',
          title: '文字を表示できます',
          body: '細かい説明をbodyに指定して書くことが出来ます',
          doAnimateImage: true),
      PageModel(
          color: const Color(0xFFE0B3B3),
          imageAssetPath: 'assets/1.png',
          title: '左右のスワイプ',
          body: 'NEXTを押さなくても左右にスワイプすることで画面の切替が出来ます',
          doAnimateImage: true),
          */
      PageModel.withChild(
          child: const Padding(
              padding: EdgeInsets.only(bottom: 25.0),
              child: Text(
                "さあ、始めましょう",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                ),
              )),
          color: const Color(0xFFE0B3B3),
          doAnimateChild: true)
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dotto チュートリアル'),
      ),
      body: OverBoard(
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
