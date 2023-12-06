import 'package:flutter/material.dart';
import 'package:dotto/components/kadai.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dotto/components/setting_user_info.dart';
import 'dart:convert';
import 'package:dotto/repository/firebase_get_kadai.dart';

class KadaiHiddenScreen extends StatefulWidget {
  const KadaiHiddenScreen({
    Key? key,
    required this.deletedKadaiLists,
  }) : super(key: key);

  final List<KadaiList> deletedKadaiLists;

  @override
  State<KadaiHiddenScreen> createState() => _KadaiHiddenScreenState();
}

class _KadaiHiddenScreenState extends State<KadaiHiddenScreen> {
  List<int> deleteList = [];
  List<Kadai> hiddenKadai = [];

  Future<void> loadDeleteList() async {
    final jsonString =
        await UserPreferences.getString(UserPreferenceKeys.kadaiDeleteList);
    if (jsonString != null) {
      setState(() {
        deleteList = List<int>.from(json.decode(jsonString));
      });
    }
  }

  Future<void> saveDeleteList() async {
    await UserPreferences.setString(
        UserPreferenceKeys.kadaiDeleteList, json.encode(deleteList));
  }

  Future<void> hiddenKadaiList() async {
    for (KadaiList kadaiList in widget.deletedKadaiLists) {
      for (Kadai kadai in kadaiList.listKadai) {
        if (deleteList.contains(kadai.id)) {
          hiddenKadai.add(kadai);
          //print(kadai.id);
        }
      }
    }
  }

  void launchUrlInExternal(Uri url) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  String stringFromDateTime(DateTime? dt) {
    if (dt == null) {
      return "";
    }
    return DateFormat('yyyy年MM月dd日 hh時mm分ss秒').format(dt);
  }

  @override
  void initState() {
    super.initState();
    loadDeleteList().then((_) {
      // 非表示の課題リストを生成
      hiddenKadaiList();
      hiddenKadai = hiddenKadai.toSet().toList();
      //print(deleteList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop("back"); // 画面遷移から戻り値を指定
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            setState(() {
              const FirebaseGetKadai().getKadaiFromFirebase();
            });
            hiddenKadaiList();
            hiddenKadai = hiddenKadai.toSet().toList();
          });
        },
        child: hiddenKadai.isEmpty
            ? Center(
                child: Text(
                  "非表示なし",
                  style: TextStyle(fontSize: deviceWidth * 0.1),
                ),
              )
            : ListView.builder(
                itemCount: hiddenKadai.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: Slidable(
                    key: UniqueKey(),
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      extentRatio: 0.5,
                      dismissible: DismissiblePane(onDismissed: () {
                        setState(() {
                          deleteList.remove(hiddenKadai[index].id);
                          hiddenKadai.remove(hiddenKadai[index]);
                          //print(deleteList);
                          saveDeleteList();
                        });
                      }),
                      children: [
                        SlidableAction(
                          label: '表示する',
                          backgroundColor: Colors.green,
                          icon: Icons.delete,
                          onPressed: (context) {
                            setState(() {
                              deleteList.remove(hiddenKadai[index].id);
                              hiddenKadai.remove(hiddenKadai[index]);
                              //print(deleteList);
                              saveDeleteList();
                            });
                          },
                        ),
                      ],
                    ),
                    child: ListTile(
                      minLeadingWidth: 0,
                      leading: const SizedBox(
                        width: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(
                        hiddenKadai[index].name!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hiddenKadai[index].courseName!,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          if ((hiddenKadai[index].endtime != null))
                            Text(
                              "終了：${stringFromDateTime(hiddenKadai[index].endtime)}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        final url = Uri.parse(hiddenKadai[index].url!);
                        launchUrlInExternal(url);
                      },
                    ),
                  ));
                },
              ),
      ),
    );
  }
}
