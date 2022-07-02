import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:drinkwater/components/my_water_chart.dart';
import 'package:drinkwater/components/my_weekend_streak.dart';
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
  Map<int, String> daysOfTheWeek = {
    1: "SEG",
    2: "TER",
    3: "QUA",
    4: "QUI",
    5: "SEX",
    6: "SÁB",
    7: "DOM",
  };

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

  List<DateTime> lastSevenDays(DateTime currentDay) {
    List<DateTime> sevenDaysList = [];

    for (var x = 7; x > 0; x--) {
      sevenDaysList.add(DateTime(
        currentDay.year,
        currentDay.month,
        currentDay.day - x,
      ));
    }

    sevenDaysList.add(DateTime.now());

    return sevenDaysList;
  }

  bool isData(int weekDay) {
    var waterStatusData = waterStatusBox.values;
    bool isData = false;
    try {
      for (var element in waterStatusData) {
        if (currentDay.weekday == 7 && weekDay == 7) {
          isData = true;
        } else if (currentDay.weekday == 7 && weekDay != 7) {
          isData = false;
        } else if (weekDay <= currentDay.weekday || weekDay == 7) {
          isData = true;
        } else {
          isData = false;
        }
      }
    } catch (err) {
      return false;
    }
    return isData;
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
      drinkFrequency /= waterStatusData.length;
    }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyWeekendStreak(
                      isTheWeekDayBeat: isTheWeekDayBeat(7),
                      weekday: "Dom",
                      isData: isData(7),
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: isTheWeekDayBeat(1),
                      weekday: "Seg",
                      isData: isData(1),
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: isTheWeekDayBeat(2),
                      weekday: "Ter",
                      isData: isData(2),
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: isTheWeekDayBeat(3),
                      weekday: "Qua",
                      isData: isData(3),
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: isTheWeekDayBeat(4),
                      weekday: "Qui",
                      isData: isData(4),
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: isTheWeekDayBeat(5),
                      weekday: "Sex",
                      isData: isData(5),
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: isTheWeekDayBeat(6),
                      weekday: "Sáb",
                      isData: isData(6),
                    ),
                  ],
                ),
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
