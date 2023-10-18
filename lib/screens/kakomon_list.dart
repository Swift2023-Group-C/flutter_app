import 'package:flutter/material.dart';
import 'package:flutter_app/components/s3.dart';
import 'package:flutter_app/components/widgets/kakomon_list_objects.dart';
import 'package:flutter_app/components/widgets/progress_indicator.dart';

class KakomonListScreen extends StatefulWidget {
  const KakomonListScreen({Key? key, required this.url}) : super(key: key);
  final int url;

  @override
  State<KakomonListScreen> createState() => _KakomonListScreenState();
}

class _KakomonListScreenState extends State<KakomonListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder(
              future: S3.instance.getListObjectsKey(url: widget.url.toString()),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('過去問はありません'),
                    );
                  }
                  return ListView(
                    children: snapshot.data!
                        .map((e) => KakomonListObjects(
                              url: e,
                            ))
                        .toList(),
                  );
                } else {
                  return createProgressIndicator();
                }
              })),
    );
  }
}
