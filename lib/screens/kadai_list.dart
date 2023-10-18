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

class KadaiListScreen extends StatefulWidget {
  const KadaiListScreen({Key? key}) : super(key: key);

  @override
  State<KadaiListScreen> createState() => _KadaiListScreenState();
}

class _KadaiListScreenState extends State<KadaiListScreen> {
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

  //保存したfinishListの状態を呼び出す
  Future<void> loadFinishList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('finishListKey');
    if (jsonString != null) {
      setState(() {
        finishList = List<bool>.from(json.decode(jsonString));
      });
    }
  }

  //finishListの状態を保存する
  Future<void> saveFinishList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(finishList);
    await prefs.setString('finishListKey', jsonString);
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
  void _resetDeleteList() {
    setState(() {
      for (int i = 0; i < deleteList.length; i++) {
        deleteList[i] = true;
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
  void _showDeleteConfirmation(int index) {
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
                deleteList[index] = !deleteList[index];
                saveDeleteList();
                setState(() {});
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
      body: FutureBuilder(
        future: const FirebaseGetKadai().getKadaiFromFirebase(),
        builder: (BuildContext context, AsyncSnapshot<List<Kadai>> snapshot) {
          if (snapshot.hasData) {
            List<Kadai> data = snapshot.data!;
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
                  onPressed: _resetDeleteList, child: const Text("リセット")),
              Expanded(
                  child: ListView.separated(
                //padding: const EdgeInsets.all(12.0),
                itemCount: deleteList.where((element) => element).length,
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
                                label: alertList[i] ? '通知off' : '通知on',
                                backgroundColor:
                                    alertList[i] ? Colors.red : Colors.green,
                                icon: alertList[i]
                                    ? Icons.notifications_off_outlined
                                    : Icons.notifications_active_outlined,
                                onPressed: (context) {
                                  setState(() {
                                    alertList[i] = !alertList[i];
                                    saveAlertList();
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
                                  _showDeleteConfirmation(i);
                                },
                              ),
                              SlidableAction(
                                label: finishList[i] ? '未完了' : '完了',
                                backgroundColor:
                                    finishList[i] ? Colors.blue : Colors.green,
                                icon: Icons.check_circle_outline,
                                onPressed: (context) {
                                  setState(() {
                                    finishList[i] = !finishList[i];
                                    saveFinishList();
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
                                  color: finishList[i]
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
                                      color: finishList[i]
                                          ? Colors.green
                                          : Colors.black54,
                                    ),
                                  ),
                                  if ((data[i].endtime != null))
                                    Text(
                                      "終了：${stringFromDateTime(data[i].endtime)}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: finishList[i]
                                            ? Colors.green
                                            : Colors.black45,
                                      ),
                                    ),
                                ],
                              ),
                              leading: Column(
                                children: [
                                  /*Icon(
                                  finishList[i] ? Icons.done : Icons.task,
                                  size: 20,
                                  color: finishList[i]
                                      ? Colors.green
                                      : Colors.grey,
                                ),*/
                                  const SizedBox(
                                    height: 8,
                                    width: 5,
                                  ),
                                  Icon(
                                    alertList[i]
                                        ? Icons.notifications_active_outlined
                                        : Icons.notifications_off_outlined,
                                    size: 30,
                                    color: alertList[i]
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                              onTap: () {
                                final url = Uri.parse(data[i].url!);
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
