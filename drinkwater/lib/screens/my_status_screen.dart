import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:drinkwater/components/my_mock_streak.dart';
import 'package:drinkwater/components/my_water_chart.dart';
import 'package:drinkwater/components/my_datapoint_streak.dart';
import 'package:drinkwater/models/data_point.dart';
import 'package:drinkwater/models/status.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constant.dart';

class MyStatusScreen extends StatefulWidget {
  const MyStatusScreen({Key key}) : super(key: key);

  @override
  State<MyStatusScreen> createState() => _MyStatusScreenState();
}

class _MyStatusScreenState extends State<MyStatusScreen> {
  Box<WaterStatus> waterStatusBox;
  var currentDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    waterStatusBox = Hive.box('statusBox');
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  Map<int, String> daysOfTheWeek = {
    1: "SEG",
    2: "TER",
    3: "QUA",
    4: "QUI",
    5: "SEX",
    6: "SÁB",
    7: "DOM",
  };

  List<DataPoint> getLastSevenDataPoints() {
    var waterStatusData = waterStatusBox.values;
    List<DateTime> sevenDaysList = lastSevenDays(currentDay);
    List<DataPoint> dataPointList = [];

    for (var day in sevenDaysList) {
      for (var waterData in waterStatusData) {
        if (day.day == waterData.statusDay.day &&
            day.month == waterData.statusDay.month) {
          dataPointList.add(DataPoint(
            weekday: daysOfTheWeek[waterData.statusDay.weekday],
            isTheWeekDayBeat: waterData.goalOfTheDayWasBeat,
          ));
        }
      }
    }

    return dataPointList;
  }

  MyDataPointStreak buildStreak(DataPoint dp) {
    return MyDataPointStreak(
      isTheWeekDayBeat: dp.isTheWeekDayBeat,
      weekday: dp.weekday,
    );
  }

  bool isTheWeekDayBeat(int weekDay) {
    var waterStatusData = waterStatusBox.values;
    WaterStatus elementDay;
    try {
      elementDay = waterStatusData
          .lastWhere((element) => element.statusDay.weekday == weekDay);
    } catch (err) {
      return false;
    }

    return elementDay.goalOfTheDayWasBeat;
  }

  Widget buildStreakRow() {
    // List<String> week = ["DOM", "SEG", "TER", "QUA", "QUI", "SEX", "SÁB"];
    List<String> week = [];
    List<DateTime> sevenDaysList = lastSevenDays(currentDay);

    for (var days in sevenDaysList) {
      week.add(daysOfTheWeek[days.weekday]);
    }

    List<MyDataPointStreak> streaks =
        getLastSevenDataPoints().map((dp) => buildStreak(dp)).toList();
    Map<String, Widget> row = {};

    for (var e in streaks) {
      row.putIfAbsent(e.weekday, () => e);
    }

    for (var wd in week) {
      row.putIfAbsent(wd, () => MyMockStreak(weekday: wd));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [for (var wd in week) row[wd]],
    );
  }

  List<DateTime> lastSevenDays(DateTime currentDay) {
    List<DateTime> sevenDaysList = [];

    for (var x = 6; x > 0; x--) {
      sevenDaysList.add(DateTime(
        currentDay.year,
        currentDay.month,
        currentDay.day - x,
      ));
    }

    sevenDaysList.add(DateTime.now());

    return sevenDaysList;
  }

  double averageDrank() {
    var waterStatusData = waterStatusBox.values;
    double averageDrank = 0.0;
    for (var element in waterStatusData) {
      averageDrank += element.amountOfWaterDrank;
      averageDrank /= waterStatusData.length;
    }
    return averageDrank;
  }

  int drinkingFrequency() {
    var waterStatusData = waterStatusBox.values;
    double drinkFrequency = 0;
    for (var element in waterStatusData) {
      drinkFrequency += element.drinkingFrequency;
    }
    drinkFrequency /= waterStatusData.length;

    return drinkFrequency.round();
  }

  int completionAverage() {
    var waterStatusData = waterStatusBox.values;
    double completionAverage = 0;
    int totalDays = waterStatusData.length;

    int goalDaysAccomplished = 0;
    for (var element in waterStatusData) {
      if (element.goalOfTheDayWasBeat == true) {
        goalDaysAccomplished++;
      }
    }
    completionAverage = (goalDaysAccomplished * 100) / totalDays;

    return completionAverage.round();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    int _currentIndex = args;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Gráfico Principal
            const MyWaterChart(),
            // Status da semana streak
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 8, top: 0, bottom: 10),
                  child: Text(
                    "Semana",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                buildStreakRow(),
              ],
            ),
            Column(
              children: [
                ListTile(
                  title: const Text("Ingestão média"),
                  trailing: Text(
                    "${averageDrank().toStringAsFixed(2)}ml",
                    style: const TextStyle(
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.blueGrey,
                  height: 20,
                ),
                ListTile(
                  title: const Text("Frequência de consumo"),
                  trailing: Text(
                    "${drinkingFrequency().toStringAsFixed(0)} vezes/dia",
                    style: const TextStyle(
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.blueGrey,
                  height: 20,
                ),
                ListTile(
                  title: const Text("Média de conclusão"),
                  trailing: Text(
                    "${completionAverage().toStringAsFixed(1)}%",
                    style: const TextStyle(
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        iconSize: 30,
        selectedIndex: _currentIndex,
        backgroundColor: kMainColor,
        showElevation: false,
        itemCornerRadius: 20,
        curve: Curves.easeIn,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          switch (_currentIndex) {
            case 0:
              {
                Navigator.pushNamed(context, '/myHomePage');
                break;
              }
            case 1:
              {
                Navigator.pushNamed(context, '/myAvailableSoonScreen',
                    arguments: _currentIndex);
                break;
              }
            case 2:
              {
                break;
              }
            default:
              {
                Navigator.pushNamed(context, '/myAvailableSoonScreen',
                    arguments: _currentIndex);
              }
          }
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(
              Icons.home,
              color: kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.notifications,
              color: kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.event_available,
              color: kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
        ],
      ),
    );
  }
}
