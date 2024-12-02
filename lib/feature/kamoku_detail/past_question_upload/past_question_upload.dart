import 'package:dotto/importer.dart';

int _term = 1;
String _text = '';

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  groupValue: _term,
                  onChanged: (value) {
                    setState(() {
                      _term = value!;
                    });
                  }),
              SizedBox(width: 10.0),
              Text('前期'),
            ],
          )

          //答えの有無　ラジオボタン
        ],
      ),
    );
  }
}
