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
import 'package:flutter_app/components/setting_user_info.dart';

class KadaiListScreen extends StatefulWidget {
  const KadaiListScreen({Key? key}) : super(key: key);

  @override
  State<KadaiListScreen> createState() => _KadaiListScreenState();
}

class _KadaiListScreenState extends State<KadaiListScreen> {
  Map<String, bool> finishMap = {};
  Map<String, bool> alertMap = {};
  Map<String, bool> deleteMap = {};
  Map<String, bool> deleteMapTrue = {};
  Map<String, bool> deleteMapFalse = {};

  List<bool> finishList = []; //完了を管理する
  List<bool> alertList = []; //通知管理
  List<bool> deleteList = []; //削除状態管理
  //List<Kadai> resetList = [];
  String? userKey;

  void launchUrl(Uri url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url.toString())) {
      // ignore: deprecated_member_use
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  //finishMapの状態を保存する
  Future<void> saveFinishMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(finishMap);
    await prefs.setString('finishMapKey', jsonString); // 正しいキーを指定
  }

  //finishMapの状態を読み込む
  Future<void> loadFinishMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('finishMapKey'); // キーを正しく指定
    if (jsonString != null) {
      setState(() {
        finishMap = Map<String, bool>.from(json.decode(jsonString));
      });
    }
  }

  //alertMapno状態を保存する
  Future<void> saveAlertMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(alertMap);
    await prefs.setString('AlertMapKey', jsonString); // 正しいキーを指定
  }

//alertMapの状態を読み込む
  Future<void> loadAlertMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('AlertMapKey'); // キーを正しく指定
    if (jsonString != null) {
      setState(() {
        alertMap = Map<String, bool>.from(json.decode(jsonString));
      });
    }
  }

  //deleteMapno状態を保存する
  Future<void> saveDeleteMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(deleteMap);
    await prefs.setString('deleteMapKey', jsonString); // 正しいキーを指定
  }

//deleteMapの状態を読み込む
  Future<void> loadDeleteMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('deleteMapKey'); // キーを正しく指定
    if (jsonString != null) {
      setState(() {
        deleteMap = Map<String, bool>.from(json.decode(jsonString));
      });
    }
  }

  //保存したalertListの状態を呼び出す
  Future<void> loadAlertList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('alertListKey');
    if (jsonString != null) {
      setState(() {
        alertList = List<bool>.from(json.decode(jsonString));
      });
    }
  }

  //alertListの状態を保存する
  Future<void> saveAlertList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(alertList);
    await prefs.setString('alertListKey', jsonString);
  }

  //保存したdeleteListの状態を呼び出す
  Future<void> loadDeleteList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('deleteListKey');
    if (jsonString != null) {
      setState(() {
        deleteList = List<bool>.from(json.decode(jsonString));
      });
    }
  }

  //deleteListの状態を保存する
  Future<void> saveDeleteList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(deleteList);
    await prefs.setString('deleteListKey', jsonString);
  }

  //deleteリストをすべてtrueに
  void _resetDeleteList(List<Kadai> data, Map<String, bool> deleteMap) {
    setState(() {
      for (int i = 0; i < data.length; i++) {
        deleteMap[data[i].url!] = false;
        print(deleteMap[data[i].url]);
      }
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

  //リストスワイプで削除アイコンタップした後の処理
  void _showDeleteConfirmation(List<Kadai> data, int i) {
    if (i >= 0 && i < data.length) {
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
                    deleteMap[data[i].url!] = true; // 削除状態を true に設定
                    print("削除");
                    for (int i = 0; i < data.length; i++) {
                      print('${deleteMap[data[i].url]}');
                    }
                    saveDeleteMap();
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
  }

  @override
  void initState() {
    super.initState();
    //loadAlertList();
    //loadDeleteList();
    getUserKey();
    loadFinishMap();
    loadAlertMap();
    loadDeleteMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: const FirebaseGetKadai().getKadaiFromFirebase(),
        builder: (BuildContext context, AsyncSnapshot<List<Kadai>> snapshot) {
          if (snapshot.hasData) {
            List<Kadai> data = snapshot.data!;
            if (finishMap.isEmpty) {
              for (int i = 0; i < data.length; i++) {
                finishMap[data[i].url!] = false; // 初期状態は「未完了」
              }
            }

            for (int i = 0; i < data.length; i++) {
              alertMap[data[i].url!] = false; // 初期状態は「アラートなし」
            }

            if (deleteMap.isEmpty) {
              for (int i = 0; i < data.length; i++) {
                deleteMap[data[i].url!] = false; // 初期状態は「未削除」
              }
            }
            deleteMap.forEach((key, value) {
              if (value == false) {
                deleteMapFalse[key] = value;
              } else if (value == true) {
                deleteMapTrue[key] = value;
              }
            });
            //print(deleteMapFalse);
            if (finishList.isEmpty) {
              finishList = List<bool>.filled(data.length, false);
            }
            if (alertList.isEmpty) {
              alertList = List<bool>.filled(data.length, false);
            }
            if (deleteList.isEmpty) {
              deleteList = List<bool>.filled(data.length, true);
            }
            return Column(children: [
              ElevatedButton(
                  onPressed: () {
                    _resetDeleteList(data, deleteMap);
                  },
                  child: const Text("リセット")),
              Expanded(
                  child: ListView.separated(
                //padding: const EdgeInsets.all(12.0),
                itemCount: deleteMapFalse.length,
                itemBuilder: (context, index) {
                  int dataIndex = 0;
                  for (int i = 0; i < data.length; i++) {
                    if (deleteList[i]) {
                      if (index == dataIndex) {
                        return Slidable(
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                label: (data[i].url != null &&
                                        alertMap[data[i].url!] == true)
                                    ? '通知off'
                                    : '通知on',
                                backgroundColor: (data[i].url != null &&
                                        alertMap[data[i].url!] == true)
                                    ? Colors.red
                                    : Colors.green,
                                icon: (data[i].url != null &&
                                        alertMap[data[i].url!] == true)
                                    ? Icons.notifications_off_outlined
                                    : Icons.notifications_active_outlined,
                                onPressed: (context) {
                                  setState(() {
                                    String currentUrl =
                                        data[i].url!; // 現在の課題のURLを取得
                                    alertMap[currentUrl] =
                                        !alertMap[currentUrl]!;
                                    print("完了");
                                    for (int i = 0; i < data.length; i++) {
                                      print('${alertMap[data[i].url]}');
                                    }
                                    saveAlertMap();
                                  });
                                },
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.5,
                            children: [
                              SlidableAction(
                                label: '削除',
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                onPressed: (context) {
                                  _showDeleteConfirmation(data, i);
                                },
                              ),
                              SlidableAction(
                                label: (data[i].url != null &&
                                        finishMap[data[i].url!] == true)
                                    ? '未完了'
                                    : '完了',
                                backgroundColor: (data[i].url != null &&
                                        finishMap[data[i].url!] == true)
                                    ? Colors.blue
                                    : Colors.green,
                                icon: Icons.check_circle_outline,
                                onPressed: (context) {
                                  setState(() {
                                    String currentUrl =
                                        data[i].url!; // 現在の課題のURLを取得
                                    finishMap[currentUrl] =
                                        !finishMap[currentUrl]!;
                                    print("完了");
                                    for (int i = 0; i < data.length; i++) {
                                      print('${finishMap[data[i].url]}');
                                    }
                                    saveFinishMap();
                                  });
                                },
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: Text(
                                data[i].name!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: (data[i].url != null &&
                                          finishMap[data[i].url!] == true)
                                      ? Colors.green
                                      : Colors.black,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[i].courseName!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: (data[i].url != null &&
                                              finishMap[data[i].url!] == true)
                                          ? Colors.green
                                          : Colors.black45,
                                    ),
                                  ),
                                  if ((data[i].endtime != null))
                                    Text(
                                      "終了：${stringFromDateTime(data[i].endtime)}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: (data[i].url != null &&
                                                finishMap[data[i].url!] == true)
                                            ? Colors.green
                                            : Colors.black45,
                                      ),
                                    ),
                                ],
                              ),
                              leading: Column(
                                children: [
                                  const SizedBox(
                                    height: 8,
                                    width: 5,
                                  ),
                                  Icon(
                                    (data[i].url != null &&
                                            alertMap[data[i].url!] == true)
                                        ? Icons.notifications_active_outlined
                                        : Icons.notifications_off_outlined,
                                    size: 30,
                                    color: (data[i].url != null &&
                                            alertMap[data[i].url!] == true)
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                              onTap: () {
                                final url =
                                    Uri.parse(data[i].url!); // 課題のURLを取得
                                launchUrl(url);
                              },
                            ),
                          ),
                        );
                      }
                      dataIndex++;
                    }
                  }
                  return Container();
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              )),
            ]);
          } else if (snapshot.hasError) {
            // 設定してね画面
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
    );
  }
}
