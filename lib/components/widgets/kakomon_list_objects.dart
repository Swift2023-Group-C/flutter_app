import 'package:flutter/material.dart';
import '../../screens/kakomon_object.dart';

class KakomonListObjects extends StatelessWidget {
  const KakomonListObjects({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return KakomonObjectScreen(url: url);
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const Offset begin = Offset(1.0, 0.0); // 右から左
                  // final Offset begin = Offset(-1.0, 0.0); // 左から右
                  const Offset end = Offset.zero;
                  final Animatable<Offset> tween = Tween(begin: begin, end: end)
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
            padding: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(url),
            ),
          ),
        ),
        const Divider(
          height: 0,
        )
      ],
    );
  }
}
