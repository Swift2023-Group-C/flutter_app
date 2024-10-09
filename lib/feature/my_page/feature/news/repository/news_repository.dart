import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/feature/my_page/feature/news/domain/news_model.dart';

class NewsRepository {
  static final NewsRepository _instance = NewsRepository._internal();
  factory NewsRepository() {
    return _instance;
  }
  NewsRepository._internal();

  Future<List<News>> getNewsListFromFirestore() async {
    final data = await FirebaseFirestore.instance
        .collection('news')
        .where('isactive', isEqualTo: true)
        .get();
    return data.docs.map((snapshot) {
      final d = snapshot.data();
      final news = News(snapshot.id, d["title"], List<String>.from(d["body"] as List),
          (d["date"] as Timestamp).toDate(),
          imageUrl: d["imageUrl"]);
      return news;
    }).toList();
  }
}
