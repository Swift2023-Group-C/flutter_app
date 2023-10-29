import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/map_detail.dart';
import 'package:flutter_app/screens/kadai_list.dart';
import 'package:flutter_app/screens/kamoku.dart';
import 'package:flutter_app/screens/home.dart';
import 'package:flutter_app/screens/map.dart';
import 'package:flutter_app/components/color_fun.dart';
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
      home: const BasePage(),
    );
  }
}

enum TabItem {
  home(
    title: 'ホーム',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    page: HomeScreen(),
  ),
  map(
    title: 'マップ',
    icon: Icons.map_outlined,
    activeIcon: Icons.map,
    page: MapScreen(),
  ),
  kamoku(
    title: '科目情報',
    icon: Icons.search_outlined,
    activeIcon: Icons.search,
    page: KamokuSearchScreen(),
  ),
  kadai(
    title: '課題',
    icon: Icons.assignment_outlined,
    activeIcon: Icons.assignment,
    page: KadaiListScreen(),
  );

  const TabItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });

  // タイトル
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;
}

final Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
  TabItem.home: GlobalKey<NavigatorState>(),
  TabItem.map: GlobalKey<NavigatorState>(),
  TabItem.kamoku: GlobalKey<NavigatorState>(),
  TabItem.kadai: GlobalKey<NavigatorState>(),
};

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late List<String?> parameter;

  Future<void> initUniLinks() async {
    linkStream.listen((String? link) {
      //さっき設定したスキームをキャッチしてここが走る。
      parameter = getQueryParameter(link);
      if (parameter[0] != null && parameter[1] != null) {
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
      debugPrint(err);
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
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  TabItem currentTab = TabItem.home;
  String appBarTitle = '';

  void _onItemTapped(int index) {
    final selectedTab = TabItem.values[index];
    if (currentTab == selectedTab) {
      _navigatorKeys[selectedTab]!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      setState(() {
        currentTab = selectedTab;
      });
    }
  }

  Future<bool> onWillPop() async {
    return !await _navigatorKeys[currentTab]!.currentState!.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: customFunColor,
          body: SafeArea(
              child: Stack(
            children: TabItem.values
                .map((tabItem) => Offstage(
                      offstage: currentTab != tabItem,
                      child: Navigator(
                        key: _navigatorKeys[tabItem],
                        onGenerateRoute: (settings) {
                          return MaterialPageRoute(
                            builder: (context) => tabItem.page,
                          );
                        },
                      ),
                    ))
                .toList(),
          )),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: TabItem.values.indexOf(currentTab),
            items: TabItem.values
                .map((tabItem) => BottomNavigationBarItem(
                    icon: Icon(tabItem.icon),
                    activeIcon: Icon(tabItem.activeIcon),
                    label: tabItem.title))
                .toList(),
            onTap: _onItemTapped,
          )),
    );
  }
}
