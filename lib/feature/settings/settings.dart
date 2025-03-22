import 'dart:io';

import 'package:dotto/components/animation.dart';
import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/settings/controller/settings_controller.dart';
import 'package:dotto/feature/settings/repository/settings_repository.dart';
import 'package:dotto/feature/settings/widget/license.dart';
import 'package:dotto/feature/settings/widget/settings_set_userkey.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/screens/app_tutorial.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void launchUrlInExternal(Uri url) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget listDialog(
      BuildContext context, String title, UserPreferenceKeys userPreferenceKeys, List list) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    ? (c) => SettingsRepository().onLogin(c, userNotifier.login, ref)
                    : (_) => SettingsRepository().onLogout(userNotifier.logout),
              ),
              // 学年
              SettingsTile.navigation(
                onPressed: (context) async {
                  String? returnText = await showDialog(
                      context: context,
                      builder: (_) {
                        return listDialog(context, '学年', UserPreferenceKeys.grade,
                            ['なし', '1年', '2年', '3年', '4年']);
                      });
                  if (returnText != null) {
                    ref.invalidate(settingsGradeProvider);
                  }
                },
                leading: const Icon(Icons.school),
                title: const Text('学年'),
                value: Text(ref.watch(settingsGradeProvider).valueOrNull ?? 'なし'),
              ),
              // コース
              SettingsTile.navigation(
                onPressed: (context) async {
                  String? returnText = await showDialog(
                      context: context,
                      builder: (_) {
                        return listDialog(context, 'コース', UserPreferenceKeys.course,
                            ['なし', '情報システム', '情報デザイン', '知能', '複雑', '高度ICT']);
                      });
                  if (returnText != null) {
                    ref.invalidate(settingsCourseProvider);
                  }
                },
                leading: const Icon(Icons.school),
                title: const Text('コース'),
                value: Text(ref.watch(settingsCourseProvider).valueOrNull ?? 'なし'),
              ),
              // ユーザーキー
              SettingsTile.navigation(
                title: const Text('課題のユーザーキー'),
                value: Text(ref.watch(settingsUserKeyProvider).valueOrNull ?? ''),
                leading: const Icon(Icons.assignment),
                onPressed: (context) {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SettingsSetUserkeyScreen(),
                    transitionsBuilder: fromRightAnimation,
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
                    transitionsBuilder: fromRightAnimation,
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
              SettingsTile.navigation(
                title: const Text('ライセンス'),
                leading: const Icon(Icons.info),
                onPressed: (context) {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const SettingsLicenseScreen(),
                    transitionsBuilder: fromRightAnimation,
                  ));
                },
              ),
              // バージョン
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
