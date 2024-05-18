import 'package:dotto/importer.dart';

Widget fromRightAnimation(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const Offset begin = Offset(1.0, 0.0); // 右から左
  const Offset end = Offset.zero;
  final Animatable<Offset> tween =
      Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
  final Animation<Offset> offsetAnimation = animation.drive(tween);
  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}
