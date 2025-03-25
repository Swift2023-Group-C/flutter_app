import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/components/animation.dart';
import 'package:dotto/components/color_fun.dart';
import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/controller/tab_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:dotto/feature/map/repository/map_repository.dart';
import 'package:dotto/feature/my_page/feature/bus/controller/bus_controller.dart';
import 'package:dotto/feature/my_page/feature/bus/repository/bus_repository.dart';
import 'package:dotto/feature/my_page/feature/news/controller/news_controller.dart';
import 'package:dotto/feature/my_page/feature/news/repository/news_repository.dart';
import 'package:dotto/feature/my_page/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/feature/my_page/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/settings/repository/settings_repository.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/download_file_from_firebase.dart';
import 'package:dotto/repository/notification.dart';
import 'package:dotto/screens/app_tutorial.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
          surface: Colors.grey.shade100,
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
            padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
            elevation: const WidgetStatePropertyAll(2),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: customFunColor,
          foregroundColor: Colors.white,
        ),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
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
      supportedLocales: const [Locale('ja'), Locale('en')],
      locale: const Locale('ja'),
    );
  }
}

class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage> {
  late List<String?> parameter;

  Future<void> initUniLinks() async {
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((event) {
      if (event.path == "/config/" && event.hasQuery) {
        final query = event.queryParameters;
        if (query.containsKey('userkey')) {
          final userKey = query['userkey'];
          if (userKey != null) {
            SettingsRepository().setUserKey(userKey, ref);
          }
        }
      }
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  }

  Future<void> setPersonalLessonIdList() async {
    await TimetableRepository().loadPersonalTimeTableList(ref);
    ref.read(twoWeekTimeTableDataProvider.notifier).state =
        await TimetableRepository().get2WeekLessonSchedule(ref);
  }

  Future<void> initBus() async {
    await ref.read(allBusStopsProvider.notifier).init();
    await ref.read(busDataProvider.notifier).init();
    ref.read(myBusStopProvider.notifier).init();
    ref.read(busRefreshProvider.notifier).start();
    BusRepository().changeDirectionOnCurrentLocation(ref);
  }

  Future<void> getNews() async {
    ref.read(newsListProvider.notifier).update(await NewsRepository().getNewsListFromFirestore());
  }

  Future<void> saveFCMToken() async {
    final didSave = await UserPreferences.getBool(UserPreferenceKeys.didSaveFCMToken) ?? false;
    debugPrint("didSave: $didSave");
    if (didSave) {
      return;
    }
    final user = ref.read(userProvider);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null && user != null) {
      final db = FirebaseFirestore.instance;
      final tokenRef = db.collection("fcm_token");
      final tokenQuery =
          tokenRef.where('uid', isEqualTo: user.uid).where('token', isEqualTo: fcmToken);
      final tokenQuerySnapshot = await tokenQuery.get();
      final tokenDocs = tokenQuerySnapshot.docs;
      if (tokenDocs.isEmpty) {
        await tokenRef.add({
          'uid': user.uid,
          'token': fcmToken,
          'last_updated': Timestamp.now(),
        });
      }
      UserPreferences.setBool(UserPreferenceKeys.didSaveFCMToken, true);
    }
  }

  Future<void> init() async {
    initUniLinks();
    initBus();
    NotificationRepository().setupInteractedMessage(ref);
    setPersonalLessonIdList();
    // await downloadFiles();
    await getNews();

    saveFCMToken();
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      await init();
    });
  }

  Future<void> downloadFiles() async {
    await Future(
      () {
        // Firebaseからファイルをダウンロード
        List<String> filePaths = [
          'map/oneweek_schedule.json',
          'home/cancel_lecture.json',
          'home/sup_lecture.json',
        ];
        for (var path in filePaths) {
          downloadFileFromFirebase(path);
        }
      },
    );
  }

  void _onItemTapped(int index) async {
    ref.read(newsFromPushNotificationProvider.notifier).reset();
    final selectedTab = TabItem.values[index];

    if (selectedTab == TabItem.map) {
      final mapUsingMapNotifier = ref.watch(mapUsingMapProvider.notifier);
      final searchDatetimeNotifier = ref.read(searchDatetimeProvider.notifier);
      searchDatetimeNotifier.reset();
      mapUsingMapNotifier.state = await MapRepository().setUsingColor(DateTime.now(), ref);
    }

    final tabItemNotifier = ref.read(tabItemProvider.notifier);
    tabItemNotifier.selected(selectedTab);
  }

  Future<bool> isAppTutorialCompleted() async {
    return await UserPreferences.getBool(UserPreferenceKeys.isAppTutorialComplete) ?? false;
  }

  void _showAppTutorial(BuildContext context) async {
    if (!await isAppTutorialCompleted()) {
      if (context.mounted) {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AppTutorial(),
          fullscreenDialog: true,
          transitionsBuilder: fromRightAnimation,
        ));
        UserPreferences.setBool(UserPreferenceKeys.isAppTutorialComplete, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showAppTutorial(context));
    final tabItem = ref.watch(tabItemProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        final bool shouldPop = !await tabNavigatorKeyMaps[tabItem]!.currentState!.maybePop();
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
                  .map((tabItemOnce) => Offstage(
                        offstage: tabItem != tabItemOnce,
                        child: Navigator(
                          key: tabNavigatorKeyMaps[tabItemOnce],
                          onGenerateRoute: (settings) {
                            return MaterialPageRoute(
                              builder: (context) => tabItemOnce.page,
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
            currentIndex: TabItem.values.indexOf(tabItem),
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
