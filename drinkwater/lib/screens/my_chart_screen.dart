import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:drinkwater/components/my_water_chart.dart';
import 'package:drinkwater/components/my_weekend_streak.dart';
import 'package:drinkwater/models/status.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constant.dart';

class MyChartScreen extends StatefulWidget {
  const MyChartScreen({Key key}) : super(key: key);

  @override
  State<MyChartScreen> createState() => _MyChartScreenState();
}

class _MyChartScreenState extends State<MyChartScreen> {
  Box<WaterStatus> waterStatusBox;

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
                  padding: EdgeInsets.only(left: 8, right: 8, top: 0),
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
                  children: const [
                    MyWeekendStreak(
                      isTheWeekDayBeat: true,
                      weekday: "Dom",
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: true,
                      weekday: "Seg",
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: false,
                      weekday: "Ter",
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: false,
                      weekday: "Qua",
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: true,
                      weekday: "Qui",
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: true,
                      weekday: "Sex",
                    ),
                    MyWeekendStreak(
                      isTheWeekDayBeat: false,
                      weekday: "Sáb",
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: const [
                ListTile(
                  title: Text("Ingestão média"),
                  trailing: Text(
                    "1024ml",
                    style: TextStyle(
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.blueGrey,
                  height: 20,
                ),
                ListTile(
                  title: Text("Frequência de consumo"),
                  trailing: Text(
                    "10 vezes/dia",
                    style: TextStyle(
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.blueGrey,
                  height: 20,
                ),
                ListTile(
                  title: Text("Média de conclusão"),
                  trailing: Text(
                    "58%",
                    style: TextStyle(
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
