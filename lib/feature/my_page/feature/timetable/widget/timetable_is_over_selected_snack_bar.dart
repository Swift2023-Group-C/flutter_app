import 'package:dotto/importer.dart';

void timetableIsOverSelectedSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('１つのコマに３つ以上選択できません')),
  );
}
