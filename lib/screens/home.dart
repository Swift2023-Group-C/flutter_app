import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/color_fun.dart';
import 'package:flutter_app/repository/narrowed_lessons.dart';
import 'package:flutter_app/screens/file_viewer.dart';
import 'package:flutter_app/screens/course_cancellation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app/screens/personal_time_table.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

final StateProvider<Map<int, List<TimeTableCourse>>>
    focusTimeTableDataProvider = StateProvider((ref) => {});
final StateProvider<DateTime> focusTimeTableDayProvider =
    StateProvider((ref) => DateTime.now());

class _HomeScreenState extends ConsumerState<HomeScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<int> personalTimeTableList = [];

  void launchUrlInExternal(Uri url) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget animation(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const Offset begin = Offset(1.0, 0.0);
    const Offset end = Offset.zero;
    final Animatable<Offset> tween = Tween(begin: begin, end: end)
        .chain(CurveTween(curve: Curves.easeInOut));
    final Animation<Offset> offsetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
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

  Widget infoButton(BuildContext context, void Function() onPressed,
      IconData icon, String title) {
    final double width = MediaQuery.sizeOf(context).width * 0.26;
    const double height = 100;
    return Container(
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
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
                )),
              )),
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

  Future<void> getOneDayTimeTable(WidgetRef ref) async {
    final focusTimeTableDay = ref.read(focusTimeTableDayProvider);
    final focusTimeTableDataNotifier =
        ref.read(focusTimeTableDataProvider.notifier);
    focusTimeTableDataNotifier.state =
        await dailyLessonSchedule(ref, focusTimeTableDay);
  }

  void setFocusTimeTableDay(DateTime dt) {
    final focusTimeTableDayNotifier =
        ref.read(focusTimeTableDayProvider.notifier);
    focusTimeTableDayNotifier.state = dt;
  }

  Widget timeTableLessonButton(TimeTableCourse? timeTableCourse) {
    Color foregroundColor = Colors.black;
    if (timeTableCourse != null) {
      if (timeTableCourse.cancel) {
        foregroundColor = Colors.grey;
      }
    }
    Map<int, String> roomName = {
      1: '講堂',
      2: '大講義室',
      3: '493',
      4: '593',
      5: '594',
      6: '595',
      7: 'R791',
      8: '494C&D',
      9: '495C&D',
      10: '484',
      11: '583',
      12: '584',
      13: '585',
      14: 'R781',
      15: 'R782',
      16: '363',
      17: '364',
      18: '365',
      19: '483',
      50: 'アトリエ',
      51: '体育館',
      90: 'その他',
      99: 'オンライン',
    };
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: foregroundColor,
          fixedSize: const Size.fromHeight(40),
          minimumSize: const Size.fromHeight(40),
          maximumSize: const Size.fromHeight(40),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 科目名表示など
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (timeTableCourse != null) ? timeTableCourse.title : '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (timeTableCourse != null)
                    Text(
                      timeTableCourse.resourseIds
                          .map((resourceId) => roomName.containsKey(resourceId)
                              ? roomName[resourceId]
                              : null)
                          .toList()
                          .join(', '),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
            // 休講情報など
            if (timeTableCourse != null)
              if (timeTableCourse.cancel)
                const Row(
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                    ),
                    Text(
                      "休講",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                )
              else if (timeTableCourse.sup)
                const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                    ),
                    Text(
                      "補講",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                )
          ],
        ),
      ),
    );
  }

  Widget timeTablePeriod(
      int period, List<TimeTableCourse> timeTableCourseList) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: timeTableCourseList.isEmpty
          ? 40
          : timeTableCourseList.length * 50 - 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            alignment: Alignment.centerLeft,
            child: Text('$period限'),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (timeTableCourseList.isEmpty)
                  timeTableLessonButton(null)
                else
                  ...timeTableCourseList
                      .map((timeTableCourse) =>
                          timeTableLessonButton(timeTableCourse))
                      .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget timeTable() {
    List<DateTime> dates = getDateRange();
    List<String> weekString = ['月', '火', '水', '木', '金', '土', '日'];
    List<Color> weekColors = [
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.blue,
      Colors.red
    ];
    final deviceWidth = MediaQuery.of(context).size.width;
    double buttonSize = 50;
    double buttonPadding = 8;
    final deviceCenter = deviceWidth / 2 - (buttonSize / 2 + buttonPadding);
    final buttonPosition =
        (DateTime.now().weekday - 1) * (buttonSize + buttonPadding);
    double initialScrollOffset =
        (buttonPosition > deviceCenter) ? buttonPosition - deviceCenter : 0;
    ScrollController controller =
        ScrollController(initialScrollOffset: initialScrollOffset);
    return Consumer(
      builder: (context, ref, child) {
        final focusTimeTableData = ref.watch(focusTimeTableDataProvider);
        final focusTimeTableDay = ref.watch(focusTimeTableDayProvider);
        return Column(
          children: [
            SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: buttonPadding, horizontal: buttonPadding / 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: dates.map((date) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: buttonPadding / 2),
                      child: ElevatedButton(
                        onPressed: () async {
                          setFocusTimeTableDay(date);
                          await getOneDayTimeTable(ref);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: focusTimeTableDay.day == date.day
                              ? customFunColor
                              : Colors.white,
                          foregroundColor: focusTimeTableDay.day == date.day
                              ? Colors.white
                              : Colors.black,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          minimumSize: Size(buttonSize, buttonSize),
                          fixedSize: Size(buttonSize, buttonSize),
                        ),
                        // 日付表示
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('dd').format(date),
                              style: TextStyle(
                                fontWeight: (focusTimeTableDay.day == date.day)
                                    ? FontWeight.bold
                                    : null,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              weekString[date.weekday - 1],
                              style: TextStyle(
                                fontSize: 9,
                                color: focusTimeTableDay.day == date.day
                                    ? Colors.white
                                    : weekColors[date.weekday - 1],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // 時間割表示
            for (int i = 1; i <= 6; i++) ...{
              timeTablePeriod(i, focusTimeTableData[i] ?? [])
            },
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getOneDayTimeTable(ref);
  }

  @override
  Widget build(BuildContext context) {
    final double infoBoxWidth = MediaQuery.sizeOf(context).width * 0.4;

    const Map<String, String> fileNamePath = {
      'バス時刻表': 'home/hakodatebus55.pdf',
      '学年歴': 'home/academic_calendar.pdf',
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
          transitionsBuilder: animation,
        ),
      );
    }, Icons.event_busy, '休講情報'));
    infoTiles.addAll(fileNamePath.entries
        .map((item) => infoButton(context, () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FileViewerScreen(
                        filename: item.key,
                        url: item.value,
                        storage: StorageService.firebase);
                  },
                  transitionsBuilder: animation,
                ),
              );
            }, Icons.picture_as_pdf, item.key))
        .toList());

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // 時間割
              timeTable(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(),
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const PersonalTimeTableScreen();
                        },
                        transitionsBuilder: animation,
                      ),
                    )
                        .then((value) async {
                      await getOneDayTimeTable(ref);
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
              infoTile(infoTiles),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
