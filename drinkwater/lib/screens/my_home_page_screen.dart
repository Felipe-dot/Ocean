import 'package:drinkwater/api/notification_api.dart';
import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:drinkwater/components/my_drawer.dart';
import 'package:drinkwater/components/my_expandable_fab.dart';
import 'package:drinkwater/components/my_fab_content.dart';
import 'package:drinkwater/models/status.dart';
import 'package:drinkwater/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../constant.dart';

class MyHomePageScreen extends StatefulWidget {
  const MyHomePageScreen({Key key}) : super(key: key);

  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  int _currentIndex = 0;
  Box<User> userBox;
  Box<WaterStatus> waterStatusBox;

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    userBox = Hive.box('userBox');
    waterStatusBox = Hive.box('waterStatusBox');
    // Iniciando o sistema de notificação do aplicativo
    var wakeUpTime = userBox.get('userWakeUpTime').userWakeUpTime;
    var sleepTime = userBox.get('userSleepTime').userSleepTime;

    // Verificando se é a hora que o usuário acorda para iniciar as notificações
    if (DateTime.now().hour >= wakeUpTime.hour) {
      NotificationApi.init(initScheduled: true);
      listenNotifications();
      NotificationApi.repeatNotification();
    } else {
      // ignore: avoid_print
      print("O usuário ainda não acordou");
    }

    // Cancelando as notificações dado a hora que o usuário dorme
    if (DateTime.now().hour >= sleepTime.hour) {
      NotificationApi.cancelAllNotifications();
    }

    if (waterStatusBox.get('goalOfTheDayWasBeat') == null) {
      // ignore: avoid_print
      print("O dia continua o mesmo");
    } else {
      if (_isDayChanged()) {
        bool goalOfTheDayWasBeat;
        //  Resetando o status da meta de ingestão de água
        var waterStatusData =
            waterStatusBox.get('WaterStatusData').waterStatusData;
        waterStatusData.last.amountOfWaterDrank = 0;
        waterStatusBox.put(
            'waterStatusData', WaterStatus(waterStatusData: waterStatusData));

        if (_getGoalStatus()) {
          goalOfTheDayWasBeat = waterStatusBox
              .get('WaterStatusData')
              .waterStatusData
              .last
              .goalOfTheDayWasBeat;
        } else {
          goalOfTheDayWasBeat = false;
        }

        waterStatusData.add(WaterStatus(
          amountOfWaterDrank: 0,
          goalOfTheDayWasBeat: goalOfTheDayWasBeat,
          statusDay: DateTime.now(),
        ));

        waterStatusBox.put(
          'waterStatusData',
          WaterStatus(
            waterStatusData: waterStatusData,
          ),
        );
      }
    }
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String payload) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePageScreen()),
    );
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  bool _isDayChanged() {
    int lastDay;
    if (waterStatusBox
            .get('waterStatusData')
            .waterStatusData
            .last
            .goalOfTheDayWasBeat !=
        null) {
      lastDay = waterStatusBox
          .get('waterStatusData')
          .waterStatusData
          .last
          .statusDay
          .day;
      // ignore: avoid_print
      print(
          "OLA DIA ${waterStatusBox.get('waterStatusData').waterStatusData.last.statusDay.day}");
    } else {
      return false;
    }
    if (lastDay != DateTime.now().day) {
      // ignore: avoid_print
      print("ONTEM = $lastDay ==== HOJE = ${DateTime.now().day}");
      return true;
    } else {
      // ignore: avoid_print
      print("ONTEM = $lastDay ==== HOJE = ${DateTime.now().day}");
      return false;
    }
  }

  int _howMuchIsMissing() {
    var waterStatusData = waterStatusBox.get('waterStatusData').waterStatusData;
    int drinkStatus = waterStatusData.last.amountOfWaterDrank;
    int drinkGoal = waterStatusData.last.drinkingWaterGoal;
    bool goalOfTheDayWasBeat;

    if (_getGoalStatus()) {
      goalOfTheDayWasBeat = waterStatusData.last.goalOfTheDayWasBeat;
    } else {
      goalOfTheDayWasBeat = false;
    }

    if (_isDayChanged() && (drinkGoal - drinkStatus) > 0) {
      waterStatusData.add(WaterStatus(
        statusDay: DateTime.now(),
        goalOfTheDayWasBeat: false,
      ));
    } else {
      waterStatusData.add(WaterStatus(
        statusDay: DateTime.now(),
        goalOfTheDayWasBeat: true,
      ));
    }

    // Verificando se a meta já foi batida
    if ((drinkGoal - drinkStatus) <= 0) {
      waterStatusBox.put(
          'waterStatusData',
          WaterStatus(
            statusDay: waterStatusData.last.statusDay,
            goalOfTheDayWasBeat: waterStatusData.last.goalOfTheDayWasBeat,
          ));
      return 0;
    } else {
      return drinkGoal - drinkStatus;
    }
  }

  double _percentageCalc() {
    var waterStatusData = waterStatusBox.get('waterStatusData').waterStatusData;
    int drinkStatus = waterStatusData.last.amountOfWaterDrank;
    int drinkGoal = waterStatusData.last.drinkingWaterGoal;

    double percentage = (drinkStatus * 100) / drinkGoal;

    // Aplicando regra de três
    return percentage > 100 ? 100 : percentage;
  }

  bool _getGoalStatus() {
    if (waterStatusBox
            .get('waterStatusData')
            .waterStatusData
            .last
            .goalOfTheDayWasBeat ==
        null) {
      return false;
    } else {
      var result = waterStatusBox
          .get('waterStatusData')
          .waterStatusData
          .last
          .goalOfTheDayWasBeat;
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    var waterStatusData = waterStatusBox.get('waterStatusData').waterStatusData;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _getGoalStatus() ? kMainColor : kWhite,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset(
                'assets/images/menuIcon.png',
                height: 23,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: _getGoalStatus() ? kMainColor : kWhite,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getGoalStatus()
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(45),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 140),
                                child: const Text(
                                  "ml",
                                  style: TextStyle(
                                    color: kGreenAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Text(
                                "${waterStatusData.last.amountOfWaterDrank}",
                                style: const TextStyle(
                                  color: kGreenAccent,
                                  fontSize: 60,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 75),
                          height: 80,
                          decoration: const BoxDecoration(
                            color: kMainColor,
                            image: DecorationImage(
                              alignment: Alignment.bottomCenter,
                              scale: 0.5,
                              image: AssetImage(
                                'assets/images/meta_batida.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const Text(
                          "Parabéns!",
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          "Suas metas de hoje foram cumpridas",
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 5.0,
                          percent: _percentageCalc() / 100,
                          center: Text(
                            "${_percentageCalc().toStringAsFixed(0)}%",
                            style: const TextStyle(
                              color: kMainColor,
                              fontSize: 25,
                            ),
                          ),
                          progressColor: kDark1,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 140),
                              child: const Text(
                                "ml",
                                style: TextStyle(
                                  color: kMainColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              "${waterStatusData.last.amountOfWaterDrank}",
                              style: const TextStyle(
                                color: kMainColor,
                                fontSize: 60,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              "faltando: ${_howMuchIsMissing()}",
                              style: const TextStyle(
                                color: kLightBlue2,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              _getGoalStatus()
                  ? Container()
                  : Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        color: kWhite,
                        image: DecorationImage(
                          alignment: Alignment.bottomCenter,
                          scale: 0.5,
                          image: AssetImage(
                            'assets/images/wave.png',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: MyExpandableFab(
        distance: 100.0,
        children: [
          MyFabContent(
            myIconImageAsset: 'assets/images/copo.png',
            myFABContentText: '200ml',
            myFunction: () {
              waterStatusData.last.amountOfWaterDrank += 200;
              setState(() {});
              _howMuchIsMissing();
            },
          ),
          MyFabContent(
            myIconImageAsset: 'assets/images/garrafa.png',
            myFABContentText: '350ml',
            myFunction: () {
              waterStatusData.last.amountOfWaterDrank += 350;
              setState(() {});
              _howMuchIsMissing();
            },
          ),
          MyFabContent(
            myIconImageAsset: 'assets/images/jarra.png',
            myFABContentText: '700ml',
            myFunction: () {
              waterStatusData.last.amountOfWaterDrank += 700;
              setState(() {});
              _howMuchIsMissing();
            },
          ),
        ],
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
                Navigator.pushNamed(context, '/myChartScreen',
                    arguments: _currentIndex);
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
