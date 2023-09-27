import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/components/kadai.dart';
import 'package:flutter_app/repository/firebase_get_kadai.dart';

class KadaiListScreen extends StatefulWidget {
  const KadaiListScreen({Key? key}) : super(key: key);

  @override
  State<KadaiListScreen> createState() => _KadaiListScreenState();
}

class _KadaiListScreenState extends State<KadaiListScreen> {
  FirebaseGetKadai firebaseGetKadai =
      const FirebaseGetKadai("swift2023c_hope_user_key_f10EvmEDa7k6bmpi");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder(
                future: firebaseGetKadai.getKadaiFromFirebase(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Kadai>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data!
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5),
                              child: ListTile(
                                title: Text(e.name!),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  } else {
                    return const Center(child: Text("Error"));
                  }
                })));
  }
}
