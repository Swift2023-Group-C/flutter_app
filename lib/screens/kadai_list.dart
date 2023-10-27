import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_app/components/kadai.dart';
import 'package:flutter_app/repository/firebase_get_kadai.dart';
import 'package:flutter_app/components/setting_user_info.dart';
import 'package:flutter_app/components/widgets/progress_indicator.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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

  void launchUrlInExternal(Uri url) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> loadFinishList() async {
    final jsonString = await UserPreferences.getFinishList();
    if (jsonString != null) {
      setState(() {
        finishList = List<int>.from(json.decode(jsonString));
      });
    }
  }

  Future<void> saveFinishList() async {
    await UserPreferences.setFinishList(json.encode(finishList));
  }

  Future<void> loadAlertList() async {
    final jsonString = await UserPreferences.getAlertList();
    if (jsonString != null) {
      setState(() {
        alertList = List<int>.from(json.decode(jsonString));
      });
    }
  }

  Future<void> saveAlertList() async {
    await UserPreferences.setAlertList(json.encode(alertList));
  }

  Future<void> loadDeleteList() async {
    final jsonString = await UserPreferences.getDeleteList();
    if (jsonString != null) {
      setState(() {
        deleteList = List<int>.from(json.decode(jsonString));
      });
    }
  }

  Future<void> saveDeleteList() async {
    await UserPreferences.setDeleteList(json.encode(deleteList));
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

  ActionPane _kadaiStartSlidable(Kadai kadai) {
    return ActionPane(
      motion: const StretchMotion(),
      extentRatio: 0.25,
      children: [
        SlidableAction(
          label: alertList.contains(kadai.id) ? '通知off' : '通知on',
          backgroundColor:
              alertList.contains(kadai.id) ? Colors.red : Colors.green,
          icon: alertList.contains(kadai.id)
              ? Icons.notifications_off_outlined
              : Icons.notifications_active_outlined,
          onPressed: (context) {
            if (alertList.contains(kadai.id)) {
              setState(() {
                alertList.remove(kadai.id!);
                print(alertList);
                saveAlertList();
              });
            } else {
              setState(() {
                alertList.add(kadai.id!);
                print(alertList);
                saveAlertList();
              });
            }
          },
        ),
      ],
    );
  }

  ActionPane _kadaiEndSlidable(Kadai kadai) {
    return ActionPane(
      motion: const StretchMotion(),
      extentRatio: 0.5,
      children: [
        SlidableAction(
          label: finishList.contains(kadai.id) ? '未完了' : '完了',
          backgroundColor:
              finishList.contains(kadai.id) ? Colors.blue : Colors.green,
          icon: finishList.contains(kadai.id) ? Icons.check : Icons.check,
          onPressed: (context) {
            if (finishList.contains(kadai.id)) {
              setState(() {
                finishList.remove(kadai.id!);
                print(finishList);
                saveFinishList();
              });
            } else {
              setState(() {
                finishList.add(kadai.id!);
                print(finishList);
                saveFinishList();
              });
            }
          },
        ),
        SlidableAction(
          label: '削除',
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (context) {
            setState(() {
              deleteList.add(kadai.id!);
              saveDeleteList();
            });
          },
        ),
      ],
    );
  }

  TextStyle _titleTextStyle(bool green) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: green ? Colors.green : Colors.black,
    );
  }

  Widget _kadaiListView(List<KadaiList> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        if (data[index].hiddenKadai(deleteList).isEmpty) {
          return Container();
        } else if (data[index].hiddenKadai(deleteList).length == 1) {
          // 1個の場合
          var kadai = data[index].hiddenKadai(deleteList).first;
          return Card(
              child: Slidable(
            startActionPane: _kadaiStartSlidable(kadai),
            endActionPane: _kadaiEndSlidable(kadai),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                kadai.name!,
                style: _titleTextStyle(finishList.contains(kadai.id)),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kadai.courseName!,
                    style: TextStyle(
                      fontSize: 14,
                      color: finishList.contains(kadai.id)
                          ? Colors.green
                          : Colors.black54,
                    ),
                  ),
                  if ((kadai.endtime != null))
                    Text(
                      "終了：${stringFromDateTime(kadai.endtime)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: finishList.contains(kadai.id)
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
                    alertList.contains(kadai.id)
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_off_outlined,
                    size: 30,
                    color: alertList.contains(kadai.id)
                        ? Colors.green
                        : Colors.grey,
                  ),
                ],
              ),
              onTap: () {
                final url = Uri.parse(kadai.url!);
                launchUrlInExternal(url);
              },
            ),
          ));
        }

        // 2個以上の場合
        return Card(
          child: ExpansionTile(
            title: Text(
              data[index].courseName,
              style: _titleTextStyle(false),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data[index].hiddenKadai(deleteList).length.toString()}個の課題",
                ),
                if ((data[index].endtime != null))
                  Text(
                    "終了：${stringFromDateTime(data[index].endtime)}",
                  ),
                if (data[index].endtime == null) const Text("期限なし"),
              ],
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data[index].hiddenKadai(deleteList).map((kadai) {
                  return Column(children: [
                    const Divider(
                      height: 0,
                    ),
                    Slidable(
                      startActionPane: _kadaiStartSlidable(kadai),
                      endActionPane: _kadaiEndSlidable(kadai),
                      child: ListTile(
                        minLeadingWidth: 20,
                        leading: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Icon(
                              alertList.contains(kadai.id)
                                  ? Icons.notifications_active
                                  : Icons.notifications_off,
                              size: 20,
                              color: alertList.contains(kadai.id)
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ],
                        ),
                        title: Text(kadai.name ?? ""),
                        onTap: () {
                          final url = Uri.parse(kadai.url ?? "");
                          launchUrlInExternal(url);
                        },
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
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
              return _kadaiListView(snapshot.data!);
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
