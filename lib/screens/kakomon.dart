import 'package:flutter/material.dart';
import 'kakomon_list.dart';

class KakomonScreen extends StatelessWidget {
  const KakomonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> subject = ['ソフトウェア設計論Ⅱ', '技術者倫理', 'システム管理方法論'];
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('過去問')),
        ),
        body: ListView(
          children: [
            for (int i = 0; i < subject.length; i++) ...{
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return KakomonListScreen(url: subject[i]);
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final Offset begin = Offset(1.0, 0.0); // 右から左
                        // final Offset begin = Offset(-1.0, 0.0); // 左から右
                        final Offset end = Offset.zero;
                        final Animatable<Offset> tween =
                            Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: Curves.easeInOut));
                        final Animation<Offset> offsetAnimation =
                            animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: Text(
                      subject[i],
                      style: const TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 0,
              ),
            }
          ],
        ));
  }
}
