import 'package:flutter/material.dart';
import 'package:flutter_app/components/setting_user_info.dart';
import 'dart:convert';

class PersonalTimeTableScreen extends StatefulWidget {
  PersonalTimeTableScreen({Key? key}) : super(key: key);

  @override
  State<PersonalTimeTableScreen> createState() =>
      _PersonalTimeTableScreenState();
}

class _PersonalTimeTableScreenState extends State<PersonalTimeTableScreen> {
  List<int> personalTimeTableList = [];

  Future<void> loadPersonalTimeTableList() async {
    final jsonString = await UserPreferences.getFinishList();
    if (jsonString != null) {
      setState(() {
        personalTimeTableList = List<int>.from(json.decode(jsonString));
      });
    }
  }

  Future<void> savePersonalTimeTableList() async {
    await UserPreferences.setFinishList(json.encode(personalTimeTableList));
  }

  @override
  void initState() {
    super.initState();
    loadPersonalTimeTableList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('時間割'),
        ),
        body: ListView.builder(
            itemCount: personalTimeTableList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  personalTimeTableList[index].toString(),
                ),
                onTap: () {
                  print(personalTimeTableList[index]);
                },
              );
            }));
  }
}
