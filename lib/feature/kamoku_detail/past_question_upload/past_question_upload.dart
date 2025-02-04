import 'package:dotto/importer.dart';

// ラジオボタンの状態を管理するクラス
class RadioButtonState extends StateNotifier<int> {
  RadioButtonState() : super(1);

  void setTerm(int value) {
    state = value;
  }
}

// ラジオボタンの状態を管理するプロバイダー
final termProvider = StateNotifierProvider<RadioButtonState, int>((ref) => RadioButtonState());

// 答えの有無を管理するクラス
class AnsState extends StateNotifier<int> {
  AnsState() : super(3);

  void setAns(int value) {
    state = value;
  }
}

// 答えの有無を管理するプロバイダー
final ansProvider = StateNotifierProvider<AnsState, int>((ref) => AnsState());

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final term = ref.watch(termProvider);
    final ans = ref.watch(ansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("過去問アップロード"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              onPressed: () {},
              child: const SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'ファイルを選択',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //年度選択　4年前から今年度まで
          DropdownButton<int>(
            // value: funchDate.month,
            onChanged: (int? value) {},
            items: <int>[for (int i = 1; i <= 12; i++) i].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text("$value年度"),
              );
            }).toList(),
          ),

          //中間期末選択　ラジオボタン
          Row(
            children: [
              Radio(
                  value: 1,
                  groupValue: term,
                  onChanged: (int? value) {
                    ref.read(termProvider.notifier).setTerm(value!);
                  }),
              const Text('中間'),
              Radio(
                value: 2,
                groupValue: term,
                onChanged: (int? value) {
                  ref.read(termProvider.notifier).setTerm(value!);
                },
              ),
              const Text('期末'),
            ],
          ),
          //答えの有無　ラジオボタン
          Row(
            children: [
              Radio(
                  value: 3,
                  groupValue: ans,
                  onChanged: (int? value) {
                    ref.read(ansProvider.notifier).setAns(value!);
                  }),
              const Text('答えあり'),
              Radio(
                value: 2,
                groupValue: ans,
                onChanged: (int? value) {},
              ),
              const Text('答えなし'),
            ],
          ),
        ],
      ),
    );
  }
}
