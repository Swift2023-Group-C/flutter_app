import 'package:flutter/material.dart';
import 'package:flutter_app/screens/file_viewer.dart';
import 'package:flutter_app/screens/setting.dart';
import 'package:flutter_app/screens/app_usage_guide.dart';

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

  @override
  Widget build(BuildContext context) {
    const Map<String, String> fileNamePath = {
      '前期時間割': 'home/timetable_first.pdf',
      '後期時間割': 'home/timetable_second.pdf',
      '学年歴': 'home/academic_calendar.pdf',
      'バス時刻表': 'home/hakodatebus55.pdf'
    };
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //const Text('ホーム', style: TextStyle(fontSize: 32.0)),
            ElevatedButton.icon(
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
              label: const Text(
                '設定',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 50),
              ),
            ),
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
            ...fileNamePath.entries
                .map((item) => ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return FileViewerScreen(
                              filename: item.key,
                              url: item.value,
                              storage: StorageService.firebase);
                        },
                        transitionsBuilder: animation,
                      ));
                    },
                    child: Text(item.key)))
                .toList(),
          ],
        ),
      ),
    );
  }
}
