import 'dart:async';
import 'dart:convert';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uni_links/uni_links.dart';

import 'package:dotto/importer.dart';
import 'package:dotto/screens/app_tutorial.dart';
import 'package:dotto/repository/download_file_from_firebase.dart';
import 'package:dotto/repository/narrowed_lessons.dart';
import 'package:dotto/screens/kadai_list.dart';
import 'package:dotto/screens/kamoku.dart';
import 'package:dotto/screens/home.dart';
import 'package:dotto/feature/map/map.dart';
import 'package:dotto/components/color_fun.dart';
import 'package:dotto/screens/settings.dart';
import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/components/db_config.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project 03 Group C',
      theme: ThemeData(
        primarySwatch: customFunColor,
        colorScheme: ColorScheme.light(
          primary: customFunColor,
          onSurface: Colors.grey.shade900,
          background: Colors.grey.shade100,
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
            padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
            elevation: const MaterialStatePropertyAll(2),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: customFunColor,
          foregroundColor: Colors.white,
        ),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade200,
        ),
        cardTheme: const CardTheme(
          surfaceTintColor: Colors.white,
        ),
        fontFamily: 'Murecho',
      ),
      home: const BasePage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('English'), Locale('ja')],
      locale: const Locale('ja'),
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
  ),
  setting(
    title: '設定',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    page: SettingsScreen(),
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

class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage> {
  late List<String?> parameter;

  Future<void> initUniLinks() async {
    linkStream.listen((String? link) async {
      //さっき設定したスキームをキャッチしてここが走る。
      parameter = getQueryParameter(link);
      if (parameter[0] != null && parameter[1] != null) {
        if (parameter[0] == 'config') {
          final String userKey = parameter[1]!;
          final RegExp userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');
          if (userKeyPattern.hasMatch(userKey)) {
            _onItemTapped(4);
            await UserPreferences.setString(
                UserPreferenceKeys.userKey, userKey);
            ref.read(settingsUserKeyProvider.notifier).state = userKey;
          }
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
    Future(() async {
      await initUniLinks();
      await SyllabusDBConfig.setDB();
      await downloadFiles();
    });
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
    final jsonString =
        await UserPreferences.getString(UserPreferenceKeys.kadaiFinishList);
    if (jsonString != null) {
      final personalLessonIdListNotifier =
          ref.watch(personalLessonIdListProvider.notifier);
      personalLessonIdListNotifier.state =
          List<int>.from(json.decode(jsonString));
    }
  }

  Future<void> downloadFiles() async {
    // Firebaseからファイルをダウンロード
    List<String> filePaths = [
      'home/cancel_lecture.json',
      'home/sup_lecture.json',
      'map/oneweek_schedule.json',
    ];
    for (var path in filePaths) {
      await downloadFileFromFirebase(path);
    }
  }

  TabItem currentTab = TabItem.home;
  String appBarTitle = '';

  void _onItemTapped(int index) async {
    final selectedTab = TabItem.values[index];

    if (currentTab == selectedTab) {
      if (_navigatorKeys[selectedTab] != null) {
        _navigatorKeys[selectedTab]!
            .currentState!
            .popUntil((route) => route.isFirst);
      }
    } else {
      setState(() {
        currentTab = selectedTab;
      });
    }
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        final bool shouldPop =
            !await _navigatorKeys[currentTab]!.currentState!.maybePop();
        if (shouldPop) {
          if (navigator.canPop()) {
            navigator.pop();
          }
        }
      },
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
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: customFunColor,
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
