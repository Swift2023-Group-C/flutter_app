import 'package:dotto/feature/my_page/feature/news/controller/news_controller.dart';
import 'package:dotto/importer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationRepository {
  static final NotificationRepository _instance = NotificationRepository._internal();
  factory NotificationRepository() {
    return _instance;
  }
  NotificationRepository._internal();

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // final token = await messaging.getToken();
    // if (token != null) {
    //   debugPrint("FCM Token: $token");
    // }
  }

  Future<void> setupInteractedMessage(WidgetRef ref) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage, ref);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _handleMessage(message, ref),
    );
  }

  void _handleMessage(RemoteMessage message, WidgetRef ref) {
    final newsId = message.data['news'];
    if (newsId != null) {
      ref.read(newsFromPushNotificationProvider.notifier).set(newsId);
    }
  }
}
