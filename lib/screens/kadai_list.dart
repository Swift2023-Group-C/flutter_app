import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_app/components/kadai.dart';
import 'package:flutter_app/repository/firebase_get_kadai.dart';
import 'package:flutter_app/components/setting_user_info.dart';
import 'package:flutter_app/components/widgets/progress_indicator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app/components/color_fun.dart';

class KadaiListScreen extends StatefulWidget {
  const KadaiListScreen({Key? key}) : super(key: key);

  @override
  State<KadaiListScreen> createState() => _KadaiListScreenState();
}

class _KadaiListScreenState extends State<KadaiListScreen> {
  List<int> finishList = [];
  List<int> alertList = [];
  List<int> deleteList = [];
  List<KadaiList> data = [];
  List<KadaiList> filteredData = [];
  String? userKey;

  void launchUrl(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> loadFinishList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('finishListKey');
    if (jsonString != null) {
      setState(() {
        finishList = List<int>.from(json.decode(jsonString));
      });
    }
  }

  Future<void> saveFinishList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(finishList);
    await prefs.setString('finishListKey', jsonString);
  }

  Future<void> loadAlertList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('alertListKey');
    if (jsonString != null) {
      setState(() {
        alertList = List<int>.from(json.decode(jsonString));
      });
    }
  }

  Future<void> saveAlertList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(alertList);
    await prefs.setString('alertListKey', jsonString);
  }

  Future<void> loadDeleteList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('deleteListKey');
    if (jsonString != null) {
      setState(() {
        deleteList = List<int>.from(json.decode(jsonString));
      });
    }
  }

  Future<void> saveDeleteList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(deleteList);
    await prefs.setString('deleteListKey', jsonString);
  }

  void _resetDeleteList() {
    setState(() {
      deleteList.clear();
      saveDeleteList();
    });
  }

  Future<void> getUserKey() async {
    userKey = await UserPreferences.getUserKey();
  }

  String stringFromDateTime(DateTime? dt) {
    if (dt == null) {
      return "";
    }
    return DateFormat('yyyy年MM月dd日 hh時mm分ss秒').format(dt);
  }

  void _showDeleteConfirmation(int index, List<Kadai> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除の確認'),
          content: const Text('このタスクを削除しますか？'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  deleteList.add(data[index].id!);
                  saveDeleteList();
                });
                Navigator.of(context).pop();
              },
              child: const Text('削除'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadFinishList();
    loadAlertList();
    loadDeleteList();
    getUserKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.white10,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(34, 34, 34, 1),
        ),
        leading: TextButton(
          onPressed: _resetDeleteList,
          child: const Text("リセット"),
        ),
      ),
      body: GestureDetector(
        onPanDown: (details) => Slidable.of(context)?.close(),
        child: FutureBuilder(
          future: const FirebaseGetKadai().getKadaiFromFirebase(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<KadaiList>>? snapshot,
          ) {
            if (snapshot!.hasData) {
              data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    child: ExpansionTile(
                      title: Text(
                        "${data[index].courseName},${data[index].listKadai.length}",
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index].courseId.toString(),
                          ),
                          if ((data[index].endtime.year != 0))
                            Text(
                              "終了：${stringFromDateTime(data[index].endtime)}",
                            ),
                          if (data[index].endtime.year == 0) Text("期限なし"),
                        ],
                      ),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: data[index].listKadai.map((kadai) {
                            return ListTile(
                              title: Text(kadai.name ?? ""),
                              onTap: () {
                                final url = Uri.parse(kadai.url ?? "");
                                launchUrl(url);
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ユーザーキーが設定されていません",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "以下のURLから設定してください",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "パソコンでの設定をおすすめします",
                      style: TextStyle(fontSize: 20),
                    ),
                    SelectableText(
                      "https://swift2023groupc.web.app/",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              );
            } else {
              return createProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
