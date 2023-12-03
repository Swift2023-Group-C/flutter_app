import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/setting_user_info.dart';
import 'package:flutter_app/screens/app_tutorial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

StateProvider<String> settingsGradeProvider = StateProvider((ref) => 'なし');
StateProvider<String> settingsCourseProvider = StateProvider((ref) => 'なし');
StateProvider<String> settingsUserKeyProvider = StateProvider((ref) => '');

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String dropdownValueGrade = 'なし';
  User? currentUser = FirebaseAuth.instance.currentUser;
  PackageInfo? packageInfo;

  void launchUrlInExternal(Uri url) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return null;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    try {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return null;
      } else if (e.code == 'invalid-credential') {
        return null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<void> loginButton(BuildContext context) async {
    // ログインしていないなら
    if (currentUser == null) {
      final userCredential = await signInWithGoogle();
      if (userCredential != null) {
        final user = userCredential.user;
        if (user != null) {
          debugPrint(user.uid);
          if (user.email != null) {
            if (user.email!.endsWith('@fun.ac.jp')) {
              setState(() {
                currentUser = user;
              });
            } else {
              await user.delete();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('このユーザーではログインできません。')),
                );
              }
            }
          } else {
            await user.delete();
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ログインに失敗しました。')),
            );
          }
        }
      }
    } else {
      await FirebaseAuth.instance.signOut();
      setState(() {
        currentUser = null;
      });
    }
  }

  Widget animation(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const Offset begin = Offset(1.0, 0.0);
    const Offset end = Offset.zero;
    final Animatable<Offset> tween = Tween(begin: begin, end: end)
        .chain(CurveTween(curve: Curves.easeInOut));
    final Animation<Offset> offsetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  Widget listDialog(
      String title, UserPreferenceKeys userPreferenceKeys, List list) {
    return AlertDialog(
      title: Text(title),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                          await UserPreferences.setString(
                              userPreferenceKeys, list[index]);
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
    packageInfo = await PackageInfo.fromPlatform();
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: Colors.white,
          settingsSectionBackground:
              (Platform.isIOS) ? const Color(0xFFF7F7F7) : null,
        ),
        sections: [
          SettingsSection(
            title: const Text('全般'),
            tiles: <SettingsTile>[
              // Googleでログイン
              if (Platform.isIOS)
                SettingsTile.navigation(
                  title: Text(
                    (currentUser == null) ? 'ログイン' : 'ログイン中',
                  ),
                  value: (currentUser == null) ? null : const Text('ログアウト'),
                  description: Text((currentUser == null)
                      ? '未来大Googleアカウント'
                      : '${currentUser!.email}でログイン中'),
                  leading:
                      Icon((currentUser == null) ? Icons.login : Icons.logout),
                  onPressed: loginButton,
                )
              else
                SettingsTile.navigation(
                  title: Text(
                    (currentUser == null) ? 'ログイン' : 'ログアウト',
                  ),
                  value: Text((currentUser == null)
                      ? '未来大Googleアカウント'
                      : '${currentUser!.email}でログイン中'),
                  leading:
                      Icon((currentUser == null) ? Icons.login : Icons.logout),
                  onPressed: loginButton,
                ),
              // 学年
              SettingsTile.navigation(
                onPressed: (context) async {
                  String? returnText = await showDialog(
                      context: context,
                      builder: (_) {
                        return listDialog('学年', UserPreferenceKeys.grade,
                            ['なし', '1年', '2年', '3年', '4年']);
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
                    ref.read(settingsCourseProvider.notifier).state =
                        returnText;
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
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SettingsStringScreen(
                            '課題のユーザーキー',
                            ref.read(settingsUserKeyProvider),
                            settingsUserKeyProvider),
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
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AppTutorial(),
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
                value: Text(packageInfo?.version ?? ''),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsStringScreen extends StatelessWidget {
  SettingsStringScreen(this.title, this.initString, this.provider, {Key? key})
      : super(key: key);

  final String title;
  final String initString;
  final StateProvider<String> provider;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = initString;
    return Consumer(
      builder: (context, ref, child) {
        return WillPopScope(
            onWillPop: () async {
              String text = controller.text;
              final RegExp userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');
              if (text.isNotEmpty) {
                if (userKeyPattern.hasMatch(text)) {
                  await UserPreferences.setString(
                      UserPreferenceKeys.userKey, text);
                  ref.read(provider.notifier).state = text;
                }
              } else {
                await UserPreferences.setString(
                    UserPreferenceKeys.userKey, text);
                ref.read(provider.notifier).state = '';
              }
              return true;
            },
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
                ),
              ),
            ));
      },
    );
  }
}
