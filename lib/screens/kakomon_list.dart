import 'package:flutter/material.dart';
import 'package:dotto/components/s3.dart';
import 'package:dotto/components/widgets/kakomon_list_objects.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';

class KakomonListScreen extends StatefulWidget {
  const KakomonListScreen({super.key, required this.url});
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
