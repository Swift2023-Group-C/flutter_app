import 'package:dotto/feature/my_page/feature/news/repository/news_repository.dart';
import 'package:dotto/importer.dart';

final newsListProvider = FutureProvider((ref) => NewsRepository().getNewsListFromFirestore());
final newsFromPushNotificationProvider = NotifierProvider<MyBusStopNotifier, String?>(() {
  return MyBusStopNotifier();
});

class MyBusStopNotifier extends Notifier<String?> {
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
