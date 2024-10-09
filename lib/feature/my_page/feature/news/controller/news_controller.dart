import 'package:dotto/feature/my_page/feature/news/domain/news_model.dart';
import 'package:dotto/importer.dart';

final newsFromPushNotificationProvider =
    NotifierProvider<NewsFromPushNotificationNotifier, String?>(() {
  return NewsFromPushNotificationNotifier();
});
final newsListProvider = NotifierProvider<NewsListNotifier, List<News>?>(() {
  return NewsListNotifier();
});

class NewsFromPushNotificationNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void set(String newsId) {
    state = newsId;
  }

  void reset() {
    state = null;
  }
}

class NewsListNotifier extends Notifier<List<News>?> {
  @override
  List<News>? build() {
    return null;
  }

  void update(List<News> news) {
    state = news;
  }
}
