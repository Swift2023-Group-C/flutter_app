import 'package:flutter/material.dart';
import 'package:flutter_app/components/kadai.dart';
import 'package:flutter_app/repository/firebase_get_kadai.dart';
import '../components/widgets/progress_indicator.dart';
import 'package:intl/intl.dart';

class KadaiListScreen extends StatefulWidget {
  const KadaiListScreen({Key? key}) : super(key: key);

  @override
  State<KadaiListScreen> createState() => _KadaiListScreenState();
}

class _KadaiListScreenState extends State<KadaiListScreen> {
  String stringFromDateTime(DateTime? dt) {
    if (dt == null) {
      return "";
    }
    return DateFormat('yyyy年MM月dd日 hh時mm分ss秒').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: const FirebaseGetKadai().getKadaiFromFirebase(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Kadai>> snapshot) {
              if (snapshot.hasData) {
                List<Kadai> data = snapshot.data!;
                return ListView.separated(
                  padding: const EdgeInsets.all(5.0),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(data[index].name!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data[index].courseName!),
                          if ((data[index].endtime != null))
                            Text(
                                "終了：${stringFromDateTime(data[index].endtime)}"),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                );
              } else {
                return createProgressIndicator();
              }
            }));
  }
}
