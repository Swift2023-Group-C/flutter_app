import 'package:flutter/material.dart';

import 'package:dotto/screens/file_viewer.dart';

class KamokuDetailKakomonListObjects extends StatefulWidget {
  const KamokuDetailKakomonListObjects({super.key, required this.url});
  final String url;

  @override
  State<KamokuDetailKakomonListObjects> createState() =>
      _KamokuDetailKakomonListObjectsState();
}

class _KamokuDetailKakomonListObjectsState
    extends State<KamokuDetailKakomonListObjects> {
  bool _checkbox = false;

  @override
  Widget build(BuildContext context) {
    RegExp exp = RegExp(r'/(.*)$');
    RegExpMatch? match = exp.firstMatch(widget.url);
    String filename = match![1] ?? widget.url;
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FileViewerScreen(
                    url: widget.url,
                    filename: filename,
                    storage: StorageService.cloudflare,
                  );
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const Offset begin = Offset(0.0, 1.0); // 下から上
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
            padding: const EdgeInsets.all(5),
            child: ListTile(
              title: Text(filename),
              leading: Checkbox(
                value: _checkbox,
                onChanged: (bool? value) {
                  setState(() {
                    _checkbox = value!;
                  });
                },
              ),
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
