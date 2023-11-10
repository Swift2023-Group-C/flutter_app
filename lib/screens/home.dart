import 'package:flutter/material.dart';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_app/screens/file_viewer.dart';
import 'package:flutter_app/screens/setting.dart';
import 'package:flutter_app/screens/app_usage_guide.dart';
import 'package:flutter_app/screens/course_cancellation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget animation(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const Offset begin = Offset(0.0, 1.0);
    const Offset end = Offset.zero;
    final Animatable<Offset> tween = Tween(begin: begin, end: end)
        .chain(CurveTween(curve: Curves.easeInOut));
    final Animation<Offset> offsetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  Widget infoTile(List<Widget> children) {
    final length = children.length;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          for (int i = 0; i < length; i += 3) ...{
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = i; j < i + 3 && j < length; j++) ...{
                  children[j],
                }
              ],
            ),
          },
        ],
      ),
    );
  }

  Widget infoButton(BuildContext context, void Function() onPressed,
      IconData icon, String title,
      {String? subtitle}) {
    final double width = MediaQuery.sizeOf(context).width * 0.26;
    debugPrint(width.toString());
    const double height = 100;
    return Container(
        margin: const EdgeInsets.all(5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            fixedSize: Size(width, height),
          ),
          onPressed: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: width,
            height: height,
            child: Column(
              children: [
                ClipOval(
                    child: Container(
                  width: 50,
                  height: 50,
                  color: customFunColor,
                  child: Center(
                      child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  )),
                )),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade800),
                  )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    const Map<String, String> fileNamePath = {
      '前期時間割': 'home/timetable_first.pdf',
      '後期時間割': 'home/timetable_second.pdf',
      '学年歴': 'home/academic_calendar.pdf',
      'バス時刻表': 'home/hakodatebus55.pdf'
    };
    List<Widget> infoTiles = fileNamePath.entries
        .map((item) => infoButton(context, () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FileViewerScreen(
                      filename: item.key,
                      url: item.value,
                      storage: StorageService.firebase);
                },
                transitionsBuilder: animation,
              ));
            }, Icons.picture_as_pdf, item.key))
        .toList();
    infoTiles.add(infoButton(context, () {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const CourseCancellationScreen();
          },
          transitionsBuilder: animation,
        ),
      );
    }, Icons.event_busy, '休講情報'));
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const SettingScreen();
                },
                transitionsBuilder: animation,
              ),
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const AppGuideScreen();
                    },
                    transitionsBuilder: animation,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                fixedSize: const Size(250, 100),
              ),
              child: const Text('このアプリの使い方'),
            ),
            const SizedBox(height: 20),
            infoTile(infoTiles),
          ],
        ),
      ),
    );
  }
}
