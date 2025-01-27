import 'package:dotto/feature/settings/controller/settings_controller.dart';
import 'package:dotto/feature/settings/repository/settings_repository.dart';
import 'package:dotto/importer.dart';
import 'package:flutter/services.dart';

class SettingsSetUserkeyScreen extends StatelessWidget {
  SettingsSetUserkeyScreen({super.key});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('課題のユーザーキー設定'),
          ),
          body: Container(
            margin: const EdgeInsets.only(top: 40, right: 15, left: 15),
            child: Consumer(
              builder: (context, ref, child) {
                final userKey = ref.watch(settingsUserKeyProvider);
                controller.text = userKey.valueOrNull ?? '';
                return TextField(
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
                    await SettingsRepository().setUserKey(value, ref);
                  },
                );
              },
            ),
          ),
        ));
  }
}
