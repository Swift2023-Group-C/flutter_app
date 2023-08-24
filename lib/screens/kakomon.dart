import 'package:flutter/material.dart';
import '../components/S3.dart';
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
  ];
  List<String> weektime = [
    '火1',
    '火3',
    '金3',
  ];
  List<String> subject = [
    '画像認識3-ABCDEF',
    '情報ネットワーク3-ABCD',
    'オペレーティングシステム3-ABCD',
  ];
  List<int> subjectUrl = [
    108201,
    108301,
    108402,
  ];
  List<String> type = [
    '専門選択',
    '専門必修',
    '専門必修',
  ];
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
                    return KakomonListScreen(
                      url: subjectUrl[i].toString(),
                      subject: subject[i],
                    );
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
