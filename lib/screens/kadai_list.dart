import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_app/components/kadai.dart';
import 'package:flutter_app/repository/firebase_get_kadai.dart';
import 'package:flutter_app/components/setting_user_info.dart';
import 'package:flutter_app/components/widgets/progress_indicator.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';
import 'package:flutter_app/screens/kadai_hidden_list.dart';
import 'package:timezone/timezone.dart' as tz;

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
  List<KadaiList> delete = [];
  List<KadaiList> filteredData = [];
  List<Kadai> deletedKadai = [];
  String? userKey;
  var deepEq = const DeepCollectionEquality().equals;
  //ScrollController _scrollController = ScrollController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _requestAndroidPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
  }

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('payload:${details.payload}');
      },
    );
  }

  Future<int> _getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return p.length;
  }

  Future<void> _zonedScheduleNotification(Kadai kadai) async {
    DateTime t = kadai.endtime!;
    // iは通知のID 同じ数字を使うと上書きされる
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, t.month, t.day, t.hour, t.minute)
            .subtract(const Duration(days: 1));
    debugPrint(scheduledDate.toString());
    if (scheduledDate.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          kadai.id!,
          '${kadai.courseName}「${kadai.name}」',
          '締切1日前です',
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'your channel id',
              'your channel name',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

  Future<void> _cancelNotification(int i) async {
    //IDを指定して通知をキャンセル
    await flutterLocalNotificationsPlugin.cancel(i);
  }

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

  /*void _resetDeleteList() {
    setState(() {
      finishList.clear();
      alertList.clear();
      deleteList.clear();
      delete.clear();
      saveDeleteList();
      saveAlertList();
      saveFinishList();
    });
  }*/

  Future<void> getUserKey() async {
    userKey = await UserPreferences.getUserKey();
  }

  String stringFromDateTime(DateTime? dt) {
    if (dt == null) {
      return "";
    }
    return DateFormat('yyyy年MM月dd日 HH時mm分ss秒').format(dt);
  }

  void _showDeleteConfirmation(Kadai kadai) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text('削除の確認'),
              Text('${kadai.name}'),
            ],
          ),
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
                  if (!deleteList.contains(kadai.id)) {
                    deleteList.add(kadai.id!);
                  }
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

  void tmpShowDeleteConfirmation(KadaiList listkadai) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text('削除の確認'),
              Text(listkadai.courseName),
              Text('${listkadai.endtime}'),
            ],
          ),
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
                  for (Kadai kadai in listkadai.listKadai) {
                    deleteList.add(kadai.id!);
                  }
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
    if (Platform.isIOS) {
      _requestIOSPermission();
    } else if (Platform.isAndroid) {
      _requestAndroidPermission();
    }
    initNotification();
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
                alertList.removeWhere((item) => item == kadai.id);
                saveAlertList();
              });
              if (kadai.id != null) {
                _cancelNotification(kadai.id!);
              }
            } else {
              setState(() {
                alertList.add(kadai.id!);
                saveAlertList();
              });
              if (kadai.endtime != null && kadai.id != null) {
                _zonedScheduleNotification(kadai);
              }
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
      dismissible: DismissiblePane(onDismissed: () {
        setState(() {
          deleteList.add(kadai.id!);
          saveDeleteList();
        });
      }),
      children: [
        SlidableAction(
          label: finishList.contains(kadai.id) ? '未完了' : '完了',
          backgroundColor:
              finishList.contains(kadai.id) ? Colors.blue : Colors.green,
          icon: finishList.contains(kadai.id) ? Icons.check : Icons.check,
          onPressed: (context) {
            if (finishList.contains(kadai.id)) {
              setState(() {
                finishList.removeWhere((item) => item == kadai.id);
                saveFinishList();
              });
            } else {
              setState(() {
                finishList.add(kadai.id!);
                saveFinishList();
              });
            }
          },
        ),
        SlidableAction(
          label: '非表示',
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (context) {
            _showDeleteConfirmation(kadai);
          },
        ),
      ],
    );
  }

  bool listAllCheck(List<int> checklist, KadaiList listKadai) {
    if (listKadai.hiddenKadai(checklist).isNotEmpty) {
      for (Kadai kadai in listKadai.hiddenKadai(checklist)) {
        if (!deleteList.contains(kadai.id)) {
          return false;
        }
      }
      return true;
    } else {
      return true;
    }
  }

  int unFinishedList(KadaiList listkadai) {
    int count = 0;
    if (listkadai.hiddenKadai(finishList).isNotEmpty) {
      for (Kadai kadai in listkadai.hiddenKadai(finishList)) {
        if (!deleteList.contains(kadai.id)) {
          count++;
        }
      }
      return count;
    } else {
      return 0;
    }
  }

  ActionPane tmpKadaiStartSlidable(KadaiList kadaiList) {
    return ActionPane(
      motion: const StretchMotion(),
      extentRatio: 0.25,
      children: [
        SlidableAction(
          label: listAllCheck(alertList, kadaiList) ? '通知off' : '通知on',
          backgroundColor:
              listAllCheck(alertList, kadaiList) ? Colors.red : Colors.green,
          icon: listAllCheck(alertList, kadaiList)
              ? Icons.notifications_off_outlined
              : Icons.notifications_active_outlined,
          onPressed: (context) {
            if (listAllCheck(alertList, kadaiList)) {
              setState(() {
                for (Kadai kadai in kadaiList.hiddenKadai(deleteList)) {
                  alertList.removeWhere((item) => item == kadai.id);
                }
                saveAlertList();
              });
            } else {
              setState(() {
                for (Kadai kadai in kadaiList.hiddenKadai(deleteList)) {
                  alertList.add(kadai.id!);
                }
                saveAlertList();
              });
            }
          },
        ),
      ],
    );
  }

  ActionPane tmpKadaiEndSlidable(KadaiList kadaiList) {
    return ActionPane(
      motion: const StretchMotion(),
      extentRatio: 0.5,
      dismissible: DismissiblePane(onDismissed: () {
        setState(() {
          for (Kadai kadai in kadaiList.hiddenKadai(deleteList)) {
            deleteList.add(kadai.id!);
          }
          saveDeleteList();
        });
      }),
      children: [
        SlidableAction(
          label: listAllCheck(finishList, kadaiList) ? '未完了' : '完了',
          backgroundColor:
              listAllCheck(finishList, kadaiList) ? Colors.blue : Colors.green,
          icon: listAllCheck(finishList, kadaiList) ? Icons.check : Icons.check,
          onPressed: (context) {
            if (listAllCheck(finishList, kadaiList)) {
              setState(() {
                for (Kadai kadai in kadaiList.hiddenKadai(deleteList)) {
                  finishList.removeWhere((item) => item == kadai.id);
                }
                saveFinishList();
              });
            } else {
              setState(() {
                for (Kadai kadai in kadaiList.hiddenKadai(deleteList)) {
                  finishList.add(kadai.id!);
                }
                saveFinishList();
              });
            }
          },
        ),
        SlidableAction(
          label: '非表示',
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (context) {
            tmpShowDeleteConfirmation(kadaiList);
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

  TextStyle _subtitleTextStyle(bool green) {
    return TextStyle(
      fontSize: 14,
      color: green ? Colors.green : Colors.black54,
    );
  }

  bool endtimeCheck(KadaiList kadailist) {
    var now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 2));
    for (Kadai kadai in kadailist.listKadai) {
      if (kadai.endtime != null) {
        if (kadai.endtime!.isAfter(today) &&
            kadai.endtime!.isBefore(tomorrow)) {
          return true;
        }
      }
    }
    return false;
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
            key: UniqueKey(),
            startActionPane: _kadaiStartSlidable(kadai),
            endActionPane: _kadaiEndSlidable(kadai),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      kadai.name!,
                      style: _titleTextStyle(finishList.contains(kadai.id)),
                    ),
                  ),
                ],
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
                            : endtimeCheck(data[index])
                                ? Colors.red
                                : Colors.black54,
                      ),
                    ),
                ],
              ),
              minLeadingWidth: 0,
              leading: Column(
                children: [
                  Icon(
                    alertList.contains(kadai.id)
                        ? Icons.notifications_active
                        : null,
                    size: 20,
                    color: Colors.green,
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
          child: Slidable(
            key: Key(data[index].toString()),
            startActionPane: tmpKadaiStartSlidable(data[index]),
            endActionPane: tmpKadaiEndSlidable(data[index]),
            child: ExpansionTile(
              childrenPadding: const EdgeInsets.all(0),
              onExpansionChanged: null,
              title: Row(
                children: [
                  const SizedBox(width: 36),
                  Expanded(
                    child: Text(
                      data[index].courseName,
                      style: _titleTextStyle(
                          listAllCheck(finishList, data[index])),
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  const SizedBox(width: 36),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Text(
                        //"${data[index].hiddenKadai(deleteList).length.toString()}個の課題",
                        //),
                        Text(
                          "${unFinishedList(data[index])}個の課題",
                          style: _subtitleTextStyle(
                              listAllCheck(finishList, data[index])),
                        ),
                        if ((data[index].endtime != null))
                          Text(
                            "終了：${stringFromDateTime(data[index].endtime)}",
                            style: _subtitleTextStyle(
                                listAllCheck(finishList, data[index])),
                          ),
                        if (data[index].endtime == null)
                          Text(
                            "期限なし",
                            style: _subtitleTextStyle(
                                listAllCheck(finishList, data[index])),
                          ),
                      ],
                    ),
                  )
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
                        key: UniqueKey(),
                        startActionPane: _kadaiStartSlidable(kadai),
                        endActionPane: _kadaiEndSlidable(kadai),
                        child: ListTile(
                          minLeadingWidth: 0,
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                alertList.contains(kadai.id)
                                    ? Icons.notifications_active
                                    : null,
                                size: 20,
                                color: Colors.green,
                              ),
                            ],
                          ),
                          title: Text(
                            kadai.name ?? "",
                            style: TextStyle(
                                color: finishList.contains(kadai.id)
                                    ? Colors.green
                                    : Colors.black),
                          ),
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
          ),
        );
      },
    );
  }

  Widget animation(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const Offset begin = Offset(1.0, 0.0); // 開始位置（画面外から）
    const Offset end = Offset.zero; // 終了位置（画面内へ）
    final Animatable<Offset> tween = Tween(begin: begin, end: end)
        .chain(CurveTween(curve: Curves.easeInOut));
    final Animation<Offset> offsetAnimation = animation.drive(tween);

    // お洒落なアニメーションの追加例
    return FadeTransition(
      // フェードインしながらスライド
      opacity: animation, // フェード用のアニメーション
      child: SlideTransition(
        // スライド
        position: offsetAnimation, // スライド用のアニメーション
        child: child, // 子ウィジェット
      ),
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
          /*leading: TextButton(
            onPressed: _resetDeleteList,
            child: const Text("リセット"),
          ),*/
          actions: [
            TextButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          KadaiHiddenScreen(deletedKadaiLists: delete),
                      transitionsBuilder: animation),
                );

                // 画面遷移から戻ってきた際の処理
                if (result == "back") {
                  setState(() {
                    loadDeleteList();
                    const FirebaseGetKadai().getKadaiFromFirebase();
                  });
                }
              },
              child: const Text(
                "非表示リスト →",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          edgeOffset: 50,
          onRefresh: () async {
            //await Future.delayed(const Duration(seconds: 1));
            setState(() {
              const FirebaseGetKadai().getKadaiFromFirebase();
            });
            await Future.delayed(const Duration(seconds: 1));
          },
          child: GestureDetector(
            onPanDown: (details) => Slidable.of(context)?.close(),
            child: FutureBuilder(
              future: const FirebaseGetKadai().getKadaiFromFirebase(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<KadaiList>>? snapshot,
              ) {
                if (snapshot!.hasData) {
                  delete = snapshot.data!;
                  return _kadaiListView(snapshot.data!);
                } else if (snapshot.hasError) {
                  return ListView(
                    children: const [
                      ListTile(
                          title: Column(
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
                      )),
                    ],
                  );
                } else {
                  return createProgressIndicator();
                }
              },
            ),
          ),
        ));
  }
}
