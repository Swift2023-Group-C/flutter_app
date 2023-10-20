import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/map_detail.dart';
import 'package:flutter_app/screens/kadai_list.dart';
import 'package:flutter_app/screens/kamoku.dart';
import 'package:flutter_app/screens/home.dart';
import 'package:flutter_app/screens/map.dart';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_app/screens/setting.dart';
import 'package:uni_links/uni_links.dart';

import 'package:flutter_app/components/setting_user_info.dart';
import 'package:flutter_app/components/db_config.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project 03 Group C',
      theme: ThemeData(
        primarySwatch: customFunColor,
        fontFamily: 'Murecho',
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
  static const _screens = [
    HomeScreen(),
    MapScreen(),
    KamokuSearchScreen(),
    KadaiListScreen()
  ];

  static const List<BottomNavigationBarItem> _bottomNavigationBarIcon = [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'ホーム'),
    BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'マップ'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: '科目検索'),
    BottomNavigationBarItem(icon: Icon(Icons.assignment), label: '課題'),
  ];

  StreamSubscription? _sub;
  late List<String?> parameter;

  Future<void> initUniLinks() async {
    _sub = linkStream.listen((String? link) {
      //さっき設定したスキームをキャッチしてここが走る。
      print(link);
      parameter = getQueryParameter(link);
      print(parameter);
      if (parameter[0] != null && parameter[1] != null) {
        print("link: ${parameter[0]!}");
        if (parameter[0] == 'config') {
          UserPreferences.setUserKey(parameter[1]!);
          /*setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('設定が保存されました。')),
            );
          });*/
        }
      }
    }, onError: (err) {
      print(err);
    });
  }

  List<String?> getQueryParameter(String? link) {
    if (link == null) return [null, null];
    final uri = Uri.parse(link);
    List<String?> returnParam = [uri.host, uri.queryParameters['userkey']];
    return returnParam;
  }

  @override
  void initState() {
    super.initState();
    initUniLinks();
    SyllabusDBConfig.setDB();
    MapDetailMap.instance.getList();
  }

  int _selectedIndex = 0;
  String appBarTitle = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(appBarTitle)),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const SettingScreen();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const Offset begin = Offset(0.0, 1.0);
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
            ),
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: _bottomNavigationBarIcon,
          type: BottomNavigationBarType.fixed,
        ));
  }
}
