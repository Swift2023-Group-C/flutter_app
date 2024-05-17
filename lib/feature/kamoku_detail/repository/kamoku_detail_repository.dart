import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';

import 'package:dotto/repository/db_config.dart';

class KamokuDetailRepository {
  static final KamokuDetailRepository _instance =
      KamokuDetailRepository._internal();
  factory KamokuDetailRepository() {
    return _instance;
  }
  KamokuDetailRepository._internal();

  Stream<QuerySnapshot<Map<String, dynamic>>> getFeedbackListFromFirestore(
      int lessonId) {
    return FirebaseFirestore.instance
        .collection('feedback')
        .where('lessonId', isEqualTo: lessonId)
        .snapshots();
  }

  bool isLoggedinGoogle() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<bool> postFeedback(
      int lessonId, double? selectedScore, String text) async {
    final String? userKey = FirebaseAuth.instance.currentUser?.uid;
    if (userKey != "" && selectedScore != null) {
      // Firestoreで同じUserKeyとlessonIdを持つフィードバックを検索
      final querySnapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .where('User', isEqualTo: userKey)
          .where('lessonId', isEqualTo: lessonId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // 既存のフィードバックが存在してたらそれを更新
        final docId = querySnapshot.docs[0].id;
        await FirebaseFirestore.instance
            .collection('feedback')
            .doc(docId)
            .update(
          {
            'score': selectedScore,
            'detail': text,
          },
        );
      } else {
        // 既存のフィードバックが存在しなかったら新しいドキュメントを作成
        await FirebaseFirestore.instance.collection('feedback').add(
          {
            'User': userKey,
            'lessonId': lessonId,
            'score': selectedScore,
            'detail': text,
          },
        );
      }
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchDetails(int lessonId) async {
    Database database = await openDatabase(SyllabusDBConfig.dbPath);
    List<Map<String, dynamic>> details = await database
        .query('detail', where: 'LessonId = ?', whereArgs: [lessonId]);

    if (details.isNotEmpty) {
      return details.first;
    } else {
      throw Exception();
    }
  }
}
