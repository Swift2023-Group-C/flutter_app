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
  List<int> finishList = []; //完了を管理する
  List<int> alertList = []; //通知管理
  List<int> deleteList = []; //削除状態管理
  List<Kadai> data = [];
  List<Kadai> filteredData = [];
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
        finishList = List<int>.from(json.decode(jsonString));
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
        alertList = List<int>.from(json.decode(jsonString));
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
        deleteList = List<int>.from(json.decode(jsonString));
      });
    }
  }

  //deleteListの状態を保存する
  Future<void> saveDeleteList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(deleteList);
    await prefs.setString('deleteListKey', jsonString);
  }

  //deleteリストをリセット
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

  //リストスワイプで削除アイコンタップした後の処理
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
              onPressed: _resetDeleteList, child: const Text("リセット")),
        ),
        endDrawer: Drawer(
            child: ListView.builder(
          itemCount: deleteList.length,
          itemBuilder: (context, index) {
            // deleteListに含まれる課題IDに一致する課題を取得
            filteredData = data.where((kadai) {
              return deleteList.contains(kadai.id);
            }).toList();
            if (filteredData.isNotEmpty) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  filteredData[index].name!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: finishList.contains(filteredData[index].id)
                        ? Colors.green
                        : Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      filteredData[index].courseName!,
                      style: TextStyle(
                        fontSize: 14,
                        color: finishList.contains(filteredData[index].id)
                            ? Colors.green
                            : Colors.black54,
                      ),
                    ),
                    if ((filteredData[index].endtime != null))
                      Text(
                        "終了：${stringFromDateTime(filteredData[index].endtime)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: finishList.contains(filteredData[index].id)
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
                      alertList.contains(filteredData[index].id)
                          ? Icons.notifications_active_outlined
                          : Icons.notifications_off_outlined,
                      size: 30,
                      color: alertList.contains(filteredData[index].id)
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ],
                ),
                onTap: () {
                  final url = Uri.parse(filteredData[index].url!);
                  launchUrl(url);
                },
              );
            } else {
              return ListTile(
                title: Text("削除リストは空です"),
              );
            }
          },
        )),
        body: GestureDetector(
          onPanDown: (details) => Slidable.of(context)?.close(),
          child: FutureBuilder(
            future: const FirebaseGetKadai().getKadaiFromFirebase(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Kadai>> snapshot) {
              if (snapshot.hasData) {
                data = snapshot.data!;
                data.sort((a, b) {
                  final bool aInFinishList = finishList.contains(a.id);
                  final bool bInFinishList = finishList.contains(b.id);
                  if (aInFinishList && !bInFinishList) {
                    // aをfinishListに含む、bを含まない場合、aを前に配置
                    return 1;
                  } else if (!aInFinishList && bInFinishList) {
                    // bをfinishListに含む、aを含まない場合、bを前に配置
                    return -1;
                  } else {
                    // a,b両方がfinishListに含まれているか、どちらも含まれていないか
                    // または、両方のendtimeがnullの場合にはendtimeを比較して昇順にソート
                    if (a.endtime == null && b.endtime == null) {
                      return 0; // どちらもendtimeがnullなら同じとみなす
                    } else if (a.endtime == null) {
                      return 1; // aのendtimeがnullでbのendtimeが存在するなら、bを前に配置
                    } else if (b.endtime == null) {
                      return -1; // bのendtimeがnullでaのendtimeが存在するなら、aを前に配置
                    } else {
                      // aとbのendtimeを比較して昇順にソート
                      return a.endtime!.compareTo(b.endtime!);
                    }
                  }
                });
                return Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: _resetDeleteList,
                          child: const Text("リセット")),
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          for (int i = 0; i < filteredData.length; i++) {
                            print(filteredData[i].name);
                          }
                          if (deleteList.isEmpty) {
                            print("削除リストはない");
                          } else {
                            for (int i = 0; i < data.length; i++) {
                              if (deleteList.contains(data[i].id)) {
                                print(data[i].name);
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  Expanded(
                      child: ListView.separated(
                    itemCount: data.length - deleteList.length,
                    itemBuilder: (context, index) {
                      int dataIndex = 0;
                      for (int i = 0; i < data.length; i++) {
                        if (!deleteList.contains(data[i].id)) {
                          if (index == dataIndex) {
                            return Slidable(
                              startActionPane: ActionPane(
                                motion: const StretchMotion(),
                                extentRatio: 0.25,
                                children: [
                                  SlidableAction(
                                    label: alertList.contains(data[i].id)
                                        ? '通知off'
                                        : '通知on',
                                    backgroundColor:
                                        alertList.contains(data[i].id)
                                            ? Colors.red
                                            : Colors.green,
                                    icon: alertList.contains(data[i].id)
                                        ? Icons.notifications_off_outlined
                                        : Icons.notifications_active_outlined,
                                    onPressed: (context) {
                                      if (alertList.contains(data[i].id)) {
                                        setState(() {
                                          alertList.remove(data[i].id!);
                                          saveAlertList();
                                        });
                                      } else {
                                        setState(() {
                                          alertList.add(data[i].id!);
                                          saveAlertList();
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                extentRatio: 0.5,
                                children: [
                                  SlidableAction(
                                    label: '削除',
                                    backgroundColor: Colors.red,
                                    icon: Icons.delete,
                                    onPressed: (context) {
                                      _showDeleteConfirmation(i, data);
                                    },
                                  ),
                                  SlidableAction(
                                    label: finishList.contains(data[i].id)
                                        ? '未完了'
                                        : '完了',
                                    backgroundColor:
                                        finishList.contains(data[i].id)
                                            ? Colors.blue
                                            : Colors.green,
                                    icon: Icons.check_circle_outline,
                                    onPressed: (context) {
                                      if (finishList.contains(data[i].id)) {
                                        setState(() {
                                          finishList.remove(data[i].id!);
                                          saveFinishList();
                                        });
                                      } else {
                                        setState(() {
                                          finishList.add(data[i].id!);
                                          saveFinishList();
                                        });
                                      }
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
                                      color: finishList.contains(data[i].id)
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[i].courseName!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: finishList.contains(data[i].id)
                                              ? Colors.green
                                              : Colors.black54,
                                        ),
                                      ),
                                      if ((data[i].endtime != null))
                                        Text(
                                          "終了：${stringFromDateTime(data[i].endtime)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                finishList.contains(data[i].id)
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
                                        alertList.contains(data[i].id)
                                            ? Icons
                                                .notifications_active_outlined
                                            : Icons.notifications_off_outlined,
                                        size: 30,
                                        color: alertList.contains(data[i].id)
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
        ));
  }
}
