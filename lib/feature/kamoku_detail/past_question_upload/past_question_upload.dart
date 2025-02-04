import 'dart:io';

import 'package:dotto/importer.dart';
import 'package:image_picker/image_picker.dart';

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

// 画像の状態を管理するクラス
class ImageState extends StateNotifier<XFile?> {
  ImageState() : super(null);

  void setImage(XFile? image) {
    state = image;
  }
}

// 画像の状態を管理するプロバイダー
final imageProvider = StateNotifierProvider<ImageState, XFile?>((ref) => ImageState());

// 年度の状態を管理するクラス
class YearState extends StateNotifier<int> {
  YearState(int initialYear) : super(initialYear);

  void setYear(int value) {
    state = value;
  }
}

// 年度の状態を管理するプロバイダー
final yearProvider = StateNotifierProvider<YearState, int>((ref) {
  DateTime dt = DateTime.now();
  int currentYear = dt.month >= 4 ? dt.year : dt.year - 1; // 4月以降なら今年度、3月以前なら昨年度
  return YearState(currentYear);
});

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final term = ref.watch(termProvider);
    final ans = ref.watch(ansProvider);
    final image = ref.watch(imageProvider);
    final year = ref.watch(yearProvider);

    DateTime dt = DateTime.now();
    int currentYear = dt.month >= 4 ? dt.year : dt.year - 1; // 4月以降なら今年度、3月以前なら昨年度

    final ImagePicker _picker = ImagePicker();

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
              onPressed: () async {
                final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  ref.read(imageProvider.notifier).setImage(pickedImage);
                }
              },
              child: const SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('ファイルを選択', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
          ),
          if (image != null) Image.file(File(image.path)),
          // 年度選択　4年前から今年度まで
          DropdownButton<int>(
            value: year,
            onChanged: (int? value) {
              if (value != null) {
                ref.read(yearProvider.notifier).setYear(value);
              }
            },
            items: <int>[for (int i = currentYear; i >= currentYear - 4; i--) i]
                .map<DropdownMenuItem<int>>((int value) {
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
                value: 4,
                groupValue: ans,
                onChanged: (int? value) {
                  ref.read(ansProvider.notifier).setAns(value!);
                },
              ),
              const Text('答えなし'),
            ],
          ),
        ],
      ),
    );
  }
}
