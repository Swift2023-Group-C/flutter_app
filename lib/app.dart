import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/map.dart';
import 'screens/kakomon.dart';
import 'components/color_fun.dart';
import 'screens/setting.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project 03 Group C',
      theme: ThemeData(
        primarySwatch: customFunColor,
      ),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const _screens = [HomeScreen(), MapScreen(), KakomonScreen()];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter練習'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return SettingScreen();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final Offset begin = Offset(0.0, 1.0);
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
            ),
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'ホーム'),
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined), label: 'マップ'),
            BottomNavigationBarItem(
                icon: Icon(Icons.folder_copy_outlined), label: '過去問')
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
