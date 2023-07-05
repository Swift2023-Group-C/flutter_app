import 'package:flutter/material.dart';
import 'kakomon_list.dart';

class KakomonScreen extends StatefulWidget {
  const KakomonScreen({Key? key}) : super(key: key);

  @override
  State<KakomonScreen> createState() => _KakomonScreenState();
}

class _KakomonScreenState extends State<KakomonScreen> {
  final List<bool> _subjectCheckbox = [
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> weektime = ['月2', '月3', '火4', '水3', '水5', '木2'];
  List<String> subject = [
    '電気回路2-ABCDJKL',
    'ハードウェア設計2-ABCD',
    '人工知能基礎2-ABCD',
    'オペレーションズリサーチ2-ABCD',
    'システム工学2-ABCD',
    'センサ工学2-ABCD'
  ];
  List<String> type = ['専門選択', '専門選択', '専門選択', '専門必修', '専門選択', '専門選択'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const Offset begin = Offset(1.0, 0.0); // 右から左
                    // final Offset begin = Offset(-1.0, 0.0); // 左から右
                    const Offset end = Offset.zero;
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
              padding: const EdgeInsets.all(10),
              child: ListTile(
                leading: CircleAvatar(child: Text(weektime[i])),
                title: Text(subject[i]),
                subtitle: Text(type[i]),
                trailing: Checkbox(
                  value: _subjectCheckbox[i],
                  onChanged: (bool? value) {
                    setState(() {
                      _subjectCheckbox[i] = value!;
                    });
                  },
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
