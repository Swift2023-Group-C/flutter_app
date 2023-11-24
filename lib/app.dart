import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/app_tutorial.dart';
import 'package:flutter_app/components/map_detail.dart';
import 'package:flutter_app/repository/download_file_from_firebase.dart';
import 'package:flutter_app/repository/find_rooms_in_use.dart';
import 'package:flutter_app/repository/narrowed_lessons.dart';
import 'package:flutter_app/repository/read_json_file.dart';
import 'package:flutter_app/screens/kadai_list.dart';
import 'package:flutter_app/screens/kamoku.dart';
import 'package:flutter_app/screens/home.dart';
import 'package:flutter_app/screens/map.dart';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final StateProvider<Map<String, bool>> mapUsingMapProvider =
    StateProvider((ref) => {});

class BasePage extends ConsumerStatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage> {
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
    mapDownload();
    downloadcourseCancellation();
  }

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

  Future<void> loadTimeTableList() async {
    final jsonString = await UserPreferences.getFinishList();
    if (jsonString != null) {
      final personalLessonIdListNotifier =
          ref.watch(personalLessonIdListProvider.notifier);
      personalLessonIdListNotifier.state =
          List<int>.from(json.decode(jsonString));
    }
  }

  Future<void> downloadcourseCancellation() async {
    // Firebaseからファイルをダウンロード
    String courseCancellationSchedulePath = 'home/cancel_lecture.json';
    await downloadFileFromFirebase(courseCancellationSchedulePath);
  }

  Future<void> mapDownload() async {
    // Firebaseからファイルをダウンロード
    String scheduleFilePath = 'map/oneweek_schedule.json';
    await downloadFileFromFirebase(scheduleFilePath);
  }

  TabItem currentTab = TabItem.home;
  String appBarTitle = '';

  Future<Map<String, bool>> setUsingColor(DateTime dateTime) async {
    final Map<String, bool> classroomNoFloorMap = {
      "1": false,
      "2": false,
      "3": false,
      "4": false,
      "5": false,
      "6": false,
      "7": false,
      "8": false,
      "9": false,
      "10": false,
      "11": false,
      "12": false,
      "13": false,
      "14": false,
      "15": false,
      "16": false,
      "17": false,
      "18": false,
      "19": false,
      "50": false,
      "51": false
    };

    String scheduleFilePath = 'map/oneweek_schedule.json';
    Map<String, DateTime>? resourceIds;
    try {
      String fileContent = await readJsonFile(scheduleFilePath);
      resourceIds = findRoomsInUse(fileContent, dateTime);
    } catch (e) {
      debugPrint(e.toString());
      return classroomNoFloorMap;
    }

    if (resourceIds.isNotEmpty) {
      resourceIds.forEach((String resourceId, DateTime useEndTime) {
        debugPrint(resourceId);
        if (classroomNoFloorMap.containsKey(resourceId)) {
          classroomNoFloorMap[resourceId] = true;
        }
      });
    }
    return classroomNoFloorMap;
  }

  void _onItemTapped(int index) async {
    final selectedTab = TabItem.values[index];

    if (selectedTab == TabItem.map) {
      final mapUsingMapNotifier = ref.watch(mapUsingMapProvider.notifier);
      final searchDatetimeNotifier = ref.watch(searchDatetimeProvider.notifier);
      searchDatetimeNotifier.state = DateTime.now();
      mapUsingMapNotifier.state = await setUsingColor(DateTime.now());
    }
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

  Future<bool> isAppTutorialCompleted() async {
    return await UserPreferences.getBool(
            UserPreferenceKeys.isAppTutorialComplete) ??
        false;
  }

  void _showAppTutorial(BuildContext context) async {
    if (!await isAppTutorialCompleted()) {
      if (context.mounted) {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AppTutorial(),
          fullscreenDialog: true,
          transitionsBuilder: animation,
        ));
        UserPreferences.setBool(UserPreferenceKeys.isAppTutorialComplete, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showAppTutorial(context));
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
