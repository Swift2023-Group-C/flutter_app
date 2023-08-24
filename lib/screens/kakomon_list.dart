import 'package:flutter/material.dart';
import '../components/s3.dart';
import '../components/widgets/kakomon_list_objects.dart';
import '../components/widgets/progress_indicator.dart';

class KakomonListScreen extends StatefulWidget {
  const KakomonListScreen({Key? key, required this.url, required this.subject})
      : super(key: key);
  final String url;
  final String subject;

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
      appBar: AppBar(
        title: Text(widget.subject),
      ),
      body: Center(
          child: FutureBuilder(
              future: S3.instance.getListObjectsKey(url: widget.url),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.hasData) {
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
