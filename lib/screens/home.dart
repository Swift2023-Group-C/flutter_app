import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_app/screens/file_viewer.dart';
import 'package:flutter_app/screens/setting.dart';
import 'package:flutter_app/screens/app_usage_guide.dart';
import 'package:flutter_app/screens/course_cancellation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

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

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    try {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
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

  Widget infoTile(List<Widget> children) {
    final length = children.length;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          for (int i = 0; i < length; i += 3) ...{
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = i; j < i + 3 && j < length; j++) ...{
                  children[j],
                }
              ],
            ),
          },
        ],
      ),
    );
  }

  Widget infoButton(BuildContext context, void Function() onPressed,
      IconData icon, String title,
      {String? subtitle}) {
    final double width = MediaQuery.sizeOf(context).width * 0.26;
    debugPrint(width.toString());
    const double height = 100;
    return Container(
        margin: const EdgeInsets.all(5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            fixedSize: Size(width, height),
          ),
          onPressed: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: width,
            height: height,
            child: Column(
              children: [
                ClipOval(
                    child: Container(
                  width: 50,
                  height: 50,
                  color: customFunColor,
                  child: Center(
                      child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  )),
                )),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade800),
                  )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    const Map<String, String> fileNamePath = {
      '前期時間割': 'home/timetable_first.pdf',
      '後期時間割': 'home/timetable_second.pdf',
      '学年歴': 'home/academic_calendar.pdf',
      'バス時刻表': 'home/hakodatebus55.pdf'
    };
    List<Widget> infoTiles = fileNamePath.entries
        .map((item) => infoButton(context, () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FileViewerScreen(
                      filename: item.key,
                      url: item.value,
                      storage: StorageService.firebase);
                },
                transitionsBuilder: animation,
              ));
            }, Icons.picture_as_pdf, item.key))
        .toList();
    infoTiles.add(infoButton(context, () {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const CourseCancellationScreen();
          },
          transitionsBuilder: animation,
        ),
      );
    }, Icons.event_busy, '休講情報'));
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
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
        ),
      ]),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
                  fixedSize: const Size(250, 80),
                ),
                child: const Text('このアプリの使い方'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  const formUrl = 'https://forms.gle/ruo8iBxLMmvScNMFA';
                  final url = Uri.parse(formUrl);
                  launchUrlInExternal(url);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(250, 80),
                ),
                child: const Text('意見要望お聞かせください!'),
              ),
              const SizedBox(height: 20),
              // ログインボタン
              ElevatedButton(
                onPressed: () async {
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
                                const SnackBar(
                                    content: Text('このユーザーではログインできません。')),
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
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(250, 80),
                ),
                child: Text((currentUser == null)
                    ? '未来大Googleアカウントで\nサインイン'
                    : '${currentUser!.email}\nからログアウト'),
              ),
              const SizedBox(height: 20),
              infoTile(infoTiles),
            ],
          ),
        ),
      ),
    );
  }
}
