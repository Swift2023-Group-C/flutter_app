import 'package:flutter/material.dart';
import '../components/s3.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:typed_data';
import '../components/widgets/progress_indicator.dart';

class KakomonObjectScreen extends StatelessWidget {
  const KakomonObjectScreen({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(url),
      ),
      body: Center(
          child: FutureBuilder(
              future: getListObjectsString(),
              builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
                if (snapshot.hasData) {
                  return const Center(
                    child: Text('GET'),
                  );
                } else {
                  return createProgressIndicator();
                }
              })),
    );
  }

  Future<Image> getListObjectsString() async {
    final stream = await S3.instance.getObject(url: url);
    List<int> memory = [];

    await for (var value in stream) {
      memory.addAll(value);
    }
    return Image.memory(Uint8List.fromList(memory));
  }
}
