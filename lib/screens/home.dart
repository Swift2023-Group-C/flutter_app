import 'package:flutter/material.dart';
import 'package:flutter_app/screens/setting.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const Text('ホーム', style: TextStyle(fontSize: 32.0)),
          IconButton(
            icon: const Icon(
              Icons.settings,
              size: 40,
            ),
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
      )),
    );
  }
}
