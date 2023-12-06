import 'package:flutter/material.dart';
import 'package:dotto/components/kadai.dart';
import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/repository/get_firebase_realtime_db.dart';

class FirebaseGetKadai {
  const FirebaseGetKadai();
  Future<List<KadaiList>> getKadaiFromFirebase() async {
    final String userKey =
        "dotto_hope_user_key_${await UserPreferences.getString(UserPreferenceKeys.userKey)}";
    List<Kadai> kadaiList = [];
    final snapshot =
        await GetFirebaseRealtimeDB.getData('hope/users/$userKey/data');
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      data.forEach((key, value) {
        kadaiList.add(Kadai.fromFirebase(key, value));
      });
    } else {
      debugPrint('No kadai data available.');
      throw Exception();
    }
    kadaiList.sort(((a, b) {
      if (a.endtime == null) {
        return 1;
      }
      if (b.endtime == null) {
        return -1;
      }
      if (a.endtime!.compareTo(b.endtime!) == 0) {
        if (a.courseId!.compareTo(b.courseId!) == 0) {
          return a.name!.compareTo(b.name!);
        }
        return a.courseId!.compareTo(b.courseId!);
      }
      return a.endtime!.compareTo(b.endtime!);
    }));
    int? courseId;
    DateTime? endtime;
    List<Kadai>? kadaiListTmp = [];
    List<KadaiList> returnList = [];
    for (var kadai in kadaiList) {
      if (endtime == kadai.endtime && courseId == kadai.courseId) {
        kadaiListTmp.add(kadai);
      } else {
        if (courseId != null) {
          if (kadaiListTmp.isNotEmpty) {
            returnList.add(KadaiList(courseId, kadaiListTmp[0].courseName!,
                endtime, List.of(kadaiListTmp)));
            kadaiListTmp.clear();
          }
        }
        courseId = kadai.courseId;
        endtime = kadai.endtime;
        kadaiListTmp.add(kadai);
      }
    }
    return returnList;
  }
}
