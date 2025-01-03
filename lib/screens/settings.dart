import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/firebase_auth.dart';
import 'package:dotto/screens/app_tutorial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

StateProvider<String> settingsGradeProvider = StateProvider((ref) => 'なし');
StateProvider<String> settingsCourseProvider = StateProvider((ref) => 'なし');
StateProvider<String> settingsUserKeyProvider = StateProvider((ref) => '');

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  void launchUrlInExternal(Uri url) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> saveFCMToken(User user) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
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

  Future<void> onLogin(BuildContext context, Function login) async {
    final user = await FirebaseAuthRepository().signIn();
    if (user != null) {
      login(user);
      saveFCMToken(user);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ログインできませんでした。')),
        );
      }
    }
  }

  Future<void> onLogout(Function logout) async {
    await FirebaseAuthRepository().signOut();
    logout();
  }

  Widget animation(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const Offset begin = Offset(1.0, 0.0);
    const Offset end = Offset.zero;
    final Animatable<Offset> tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
    final Animation<Offset> offsetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  Widget listDialog(String title, UserPreferenceKeys userPreferenceKeys, List list) {
    return AlertDialog(
      title: Text(title),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              const Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(list[index].toString()),
                        onTap: () async {
                          await UserPreferences.setString(userPreferenceKeys, list[index]);
                          if (context.mounted) {
                            Navigator.pop(context, list[index]);
                          }
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initSettings() async {
    ref.read(settingsGradeProvider.notifier).state =
        await UserPreferences.getString(UserPreferenceKeys.grade) ?? 'なし';
    ref.read(settingsCourseProvider.notifier).state =
        await UserPreferences.getString(UserPreferenceKeys.course) ?? 'なし';
    ref.read(settingsUserKeyProvider.notifier).state =
        await UserPreferences.getString(UserPreferenceKeys.userKey) ?? '';
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initSettings();
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = ref.read(userProvider.notifier);
    final user = ref.watch(userProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: Colors.white,
          settingsSectionBackground: (Platform.isIOS) ? const Color(0xFFF7F7F7) : null,
        ),
        sections: [
          SettingsSection(
            title: const Text('全般'),
            tiles: <SettingsTile>[
              // Googleでログイン

              SettingsTile.navigation(
                title: Text(
                  (user == null) ? 'ログイン' : 'ログイン中',
                ),
                value: (Platform.isIOS)
                    ? (user == null)
                        ? null
                        : const Text('ログアウト')
                    : Text((user == null) ? '未来大Googleアカウント' : '${user.email}でログイン中'),
                description: (Platform.isIOS)
                    ? Text((user == null) ? '未来大Googleアカウント' : '${user.email}でログイン中')
                    : null,
                leading: Icon((user == null) ? Icons.login : Icons.logout),
                onPressed: (user == null)
                    ? (c) => onLogin(c, userNotifier.login)
                    : (_) => onLogout(userNotifier.logout),
              ),
              // 学年
              SettingsTile.navigation(
                onPressed: (context) async {
                  String? returnText = await showDialog(
                      context: context,
                      builder: (_) {
                        return listDialog(
                            '学年', UserPreferenceKeys.grade, ['なし', '1年', '2年', '3年', '4年']);
                      });
                  if (returnText != null) {
                    ref.read(settingsGradeProvider.notifier).state = returnText;
                  }
                },
                leading: const Icon(Icons.school),
                title: const Text('学年'),
                value: Text(ref.watch(settingsGradeProvider)),
              ),
              // コース
              SettingsTile.navigation(
                onPressed: (context) async {
                  String? returnText = await showDialog(
                      context: context,
                      builder: (_) {
                        return listDialog('コース', UserPreferenceKeys.course,
                            ['なし', '情報システム', '情報デザイン', '知能', '複雑', '高度ICT']);
                      });
                  if (returnText != null) {
                    ref.read(settingsCourseProvider.notifier).state = returnText;
                  }
                },
                leading: const Icon(Icons.school),
                title: const Text('コース'),
                value: Text(ref.watch(settingsCourseProvider)),
              ),
              // ユーザーキー
              SettingsTile.navigation(
                title: const Text('課題のユーザーキー'),
                value: Text(ref.watch(settingsUserKeyProvider)),
                leading: const Icon(Icons.assignment),
                onPressed: (context) {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => SettingsStringScreen(
                        '課題のユーザーキー', ref.read(settingsUserKeyProvider), settingsUserKeyProvider),
                    transitionsBuilder: animation,
                  ));
                },
              ),
              SettingsTile.navigation(
                title: const Text('ユーザーキーの設定は下記リンクから'),
                description: const SelectableText(
                  "https://dotto.web.app/",
                ),
                trailing: const Icon(null),
              ),
            ],
          ),

          // その他
          SettingsSection(
            title: const Text('その他'),
            tiles: <SettingsTile>[
              // アプリの使い方
              SettingsTile.navigation(
                title: const Text('アプリの使い方'),
                leading: const Icon(Icons.assignment),
                onPressed: (context) {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const AppTutorial(),
                    transitionsBuilder: animation,
                  ));
                },
              ),
              // 利用規約
              SettingsTile.navigation(
                title: const Text('利用規約&プライバシーポリシー'),
                leading: const Icon(Icons.verified_user),
                onPressed: (context) {
                  const formUrl = 'https://dotto.web.app/privacypolicy.html';
                  final url = Uri.parse(formUrl);
                  launchUrlInExternal(url);
                },
              ),
              // 利用規約
              SettingsTile.navigation(
                title: const Text('バージョン'),
                leading: const Icon(Icons.info),
                trailing: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      return Text(data.version);
                    } else {
                      return const Text('');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsStringScreen extends StatelessWidget {
  SettingsStringScreen(this.title, this.initString, this.provider, {super.key});

  final String title;
  final String initString;
  final StateProvider<String> provider;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final RegExp userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');
    controller.text = initString;
    return Consumer(
      builder: (context, ref, child) {
        return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: Container(
                margin: const EdgeInsets.only(top: 40, right: 15, left: 15),
                child: TextField(
                  controller: controller,
                  // 入力数
                  maxLength: 16,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '課題のユーザーキー',
                    hintText: '半角英数字16桁',
                  ),
                  inputFormatters: [
                    // 最大16文字まで入力可能
                    LengthLimitingTextInputFormatter(16),
                    // 半角英数字のみ許可
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9]'),
                    ),
                  ],
                  onChanged: (value) async {
                    if (value.length == 16) {
                      if (userKeyPattern.hasMatch(value)) {
                        await UserPreferences.setString(UserPreferenceKeys.userKey, value);
                        ref.read(provider.notifier).state = value;
                      }
                    } else if (value.isEmpty) {
                      await UserPreferences.setString(UserPreferenceKeys.userKey, value);
                      ref.read(provider.notifier).state = '';
                    }
                  },
                ),
              ),
            ));
      },
    );
  }
}
