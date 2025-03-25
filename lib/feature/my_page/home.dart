import 'package:collection/collection.dart';
import 'package:dotto/components/animation.dart';
import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/my_page/feature/bus/widget/bus_card_home.dart';
import 'package:dotto/feature/my_page/feature/news/controller/news_controller.dart';
import 'package:dotto/feature/my_page/feature/news/news.dart';
import 'package:dotto/feature/my_page/feature/news/news_detail.dart';
import 'package:dotto/feature/my_page/feature/news/widget/my_page_news.dart';
import 'package:dotto/feature/my_page/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/feature/my_page/feature/timetable/course_cancellation.dart';
import 'package:dotto/feature/my_page/feature/timetable/personal_time_table.dart';
import 'package:dotto/feature/my_page/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/my_page/feature/timetable/widget/my_page_timetable.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/screens/file_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<int> personalTimeTableList = [];

  void launchUrlInExternal(Uri url) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget infoTile(List<Widget> children) {
    final length = children.length;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          for (int i = 0; i < length; i += 3) ...{
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = i; j < i + 3 && j < length; j++) ...{
                  children[j],
                }
              ],
            ),
          },
        ],
      ),
    );
  }

  Widget infoButton(BuildContext context, void Function() onPressed, IconData icon, String title) {
    final double width = MediaQuery.sizeOf(context).width * 0.26;
    const double height = 100;
    return Container(
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          fixedSize: Size(width, height),
        ),
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  width: 45,
                  height: 45,
                  color: customFunColor,
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPushNotificationNews(BuildContext context, WidgetRef ref) {
    final newsList = ref.watch(newsListProvider);

    if (newsList != null) {
      final newsId = ref.watch(newsFromPushNotificationProvider);
      if (newsId != null) {
        final pushNews = newsList.firstWhereOrNull((element) => element.id == newsId);
        if (pushNews != null) {
          Navigator.of(context)
              .push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => NewsDetailScreen(pushNews),
              transitionsBuilder: fromRightAnimation,
            ),
          )
              .whenComplete(() {
            ref.read(newsFromPushNotificationProvider.notifier).reset();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPushNotificationNews(context, ref));

    final double infoBoxWidth = MediaQuery.sizeOf(context).width * 0.4;

    const Map<String, String> fileNamePath = {
      // 'バス時刻表': 'home/hakodatebus55.pdf',
      '学年暦': 'home/academic_calendar.pdf',
      '前期時間割': 'home/timetable_first.pdf',
      '後期時間割': 'home/timetable_second.pdf',
    };
    List<Widget> infoTiles = [];
    infoTiles.add(infoButton(context, () {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const CourseCancellationScreen();
          },
          transitionsBuilder: fromRightAnimation,
        ),
      );
    }, Icons.event_busy, '休講情報'));
    infoTiles.add(infoButton(context, () {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const NewsScreen();
          },
          transitionsBuilder: fromRightAnimation,
        ),
      );
    }, Icons.newspaper, 'お知らせ'));
    infoTiles.addAll(fileNamePath.entries
        .map((item) => infoButton(context, () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FileViewerScreen(
                      filename: item.key,
                      url: item.value,
                      storage: StorageService.firebase,
                    );
                  },
                  transitionsBuilder: fromRightAnimation,
                ),
              );
            }, Icons.picture_as_pdf, item.key))
        .toList());

    final twoWeekTimeTableDataNotifier = ref.read(twoWeekTimeTableDataProvider.notifier);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              // 時間割
              const MyPageTimetable(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const PersonalTimeTableScreen();
                        },
                        transitionsBuilder: fromRightAnimation,
                      ),
                    )
                        .then((value) async {
                      twoWeekTimeTableDataNotifier.state =
                          await TimetableRepository().get2WeekLessonSchedule(ref);
                    });
                  },
                  child: Text(
                    "時間割を設定する ⇀",
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const BusCardHome(),
              const SizedBox(height: 20),
              const MyPageNews(),
              const SizedBox(height: 20),
              infoTile(infoTiles),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      const formUrl = 'https://forms.gle/ruo8iBxLMmvScNMFA';
                      final url = Uri.parse(formUrl);
                      launchUrlInExternal(url);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      fixedSize: Size(infoBoxWidth, 80),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      '意見要望\nお聞かせください！',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
