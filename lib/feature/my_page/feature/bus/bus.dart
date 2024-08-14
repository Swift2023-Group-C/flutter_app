import 'package:dotto/feature/my_page/feature/bus/bus_timetable.dart';
import 'package:dotto/importer.dart';
import 'package:flutter/material.dart';

class BusScreen extends StatelessWidget {
  const BusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Screen'),
      ),
      body: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimeTableList()),
          );
        },
        child: Card(
          margin: const EdgeInsets.all(15),
          color: Colors.white,
          shadowColor: Colors.black,
          child: SizedBox(
            width: 370,
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 3, 0, 0),
                  child: Text(
                    '亀田 → 未来大',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text('09:23', style: TextStyle(fontSize: 40)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                      child: Transform.translate(
                        offset: const Offset(0, 5),
                        child: const Text('発', style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Transform.translate(
                        offset: const Offset(0, 10),
                        child: const Text('9:15着', style: TextStyle(fontSize: 15)),
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: LinearProgressIndicator(
                    value: 0.5,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(266, 3, 10, 0),
                  child: Text(
                    '出発まで15分',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//make by zaki
class TimeTableList extends StatelessWidget {
  const TimeTableList({super.key});

  Widget infoButton(BuildContext context, void Function() onPressed, IconData icon, String title) {
    //final double width = MediaQuery.sizeOf(context).width * 0.26;
    const double width = 80;
    const double height = 80;
    return Container(
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            surfaceTintColor: Colors.white,
            fixedSize: Size(width, height),
            padding: EdgeInsets.all(0),
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15))),
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
                width: 35,
                height: 35,
                //color: customFunColor,
                child: Center(
                    child: Icon(
                  icon,
                  color: Colors.grey,
                  size: 28,
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

  @override
  Widget build(BuildContext context) {
    Widget departure = infoButton(context, () {}, Icons.directions_bus, '亀田');

    Widget destination = infoButton(context, () {}, Icons.school, '未来大');

    final btn_change = IconButton(
        iconSize: 20,
        color: Colors.blue,
        onPressed: () {},
        icon: Icon(
          Icons.autorenew,
        ));

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("時刻表一覧"),
        ),
        body: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                departure,
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    // Container(
                    //   width: 86,
                    //   height: 30,
                    //   child: Image.asset('images/arrowPicture.jpg'),
                    // ),
                    btn_change,
                  ],
                ),
                destination,
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // 実際のデータ数に応じて調整
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BusTimetableScreen()),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    color: Colors.white,
                    shadowColor: Colors.black,
                    child: SizedBox(
                      width: 370,
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text('09:55', style: TextStyle(fontSize: 40)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                                child: Transform.translate(
                                  offset: const Offset(0, 5),
                                  child: const Text('発', style: TextStyle(fontSize: 15)),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Transform.translate(
                                  offset: const Offset(0, 10),
                                  child: const Text('9:39着', style: TextStyle(fontSize: 15)),
                                ),
                              )
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: LinearProgressIndicator(
                              value: 0.5,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(266, 3, 10, 0),
                            child: Text(
                              '出発まで15分',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
