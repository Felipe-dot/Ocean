import 'package:drinkwater/api/notification_api.dart';
import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:drinkwater/components/my_expandable_fab.dart';
import 'package:drinkwater/components/my_fab_content.dart';
import 'package:drinkwater/models/status.dart';
import 'package:drinkwater/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class MyHomePageScreen extends StatefulWidget {
  const MyHomePageScreen({Key? key}) : super(key: key);

  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  int _currentIndex = 0;
  late Box<User> userBox;
  late Box<WaterStatus> waterStatusBox;

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    userBox = Hive.box('userBox');
    waterStatusBox = Hive.box('statusBox');
    // Iniciando o sistema de notificação do aplicativo
    var wakeUpTime = userBox.getAt(userBox.length - 1)?.userWakeUpTime;
    var sleepTime = userBox.getAt(userBox.length - 1)?.userSleepTime;
    var notificationTimeList =
        userBox.getAt(userBox.length - 1)?.notificationTimeList;

    // Verificando se é a hora que o usuário acorda para iniciar as notificações
    if (DateTime.now().hour >= wakeUpTime!.hour) {
      NotificationApi.init(initScheduled: true);
      listenNotifications();
      try {
        notificationTimeList?.forEach((e) {
          NotificationApi.showScheduleNotification(e.hour, e.second);
        });
      } catch (err) {
        print(err);
      }

      // NotificationApi.repeatNotification();

      print("================================");
      print(notificationTimeList);
      print("================================");
    } else {
      // ignore: avoid_print
      print("O usuário ainda não acordou");
    }

    // Cancelando as notificações dado a hora que o usuário dorme
    if (DateTime.now().hour >= sleepTime!.hour) {
      NotificationApi.cancelAllNotifications();
    }

    _isDayChanged();
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
    var waterStatusData = waterStatusBox.getAt(waterStatusBox.length - 1);
    int lastDay;
    lastDay = waterStatusData!.statusDay.day;
    if (lastDay != DateTime.now().day) {
      waterStatusBox.add(WaterStatus(
        statusDay: DateTime.now(),
        goalOfTheDayWasBeat: false,
        amountOfWaterDrank: 0,
        drinkingWaterGoal: waterStatusData.drinkingWaterGoal,
        drinkingFrequency: 0,
      ));

      print("ONTEM = $lastDay ==== HOJE = ${DateTime.now().day}");
      return true;
    } else {
      print("HOJE = $lastDay ==== HOJE = ${DateTime.now().day}");
      return false;
    }
  }

  bool _getGoalStatus() {
    return waterStatusBox.getAt(waterStatusBox.length - 1)!.goalOfTheDayWasBeat;
  }

  double _percentageCalc() {
    var waterStatusData = waterStatusBox.getAt(waterStatusBox.length - 1);
    int amountOfWaterDrank = waterStatusData!.amountOfWaterDrank;
    int drinkWaterGoal = waterStatusData.drinkingWaterGoal;

    double percentage = (amountOfWaterDrank * 100) / drinkWaterGoal;

    // Aplicando regra de três
    return percentage > 100 ? 100 : percentage;
  }

  int _howMuchIsMissing() {
    var waterStatusData = waterStatusBox.getAt(waterStatusBox.length - 1);
    int amountOfWaterDrank = waterStatusData!.amountOfWaterDrank;
    int drinkWaterGoal = waterStatusData.drinkingWaterGoal;

    // Verificando se a meta já foi batida
    if ((drinkWaterGoal - amountOfWaterDrank) <= 0) {
      waterStatusData = WaterStatus(
        statusDay: waterStatusData.statusDay,
        goalOfTheDayWasBeat: true,
        amountOfWaterDrank: waterStatusData.amountOfWaterDrank,
        drinkingWaterGoal: waterStatusData.drinkingWaterGoal,
        drinkingFrequency: waterStatusData.drinkingFrequency,
      );
      waterStatusBox.putAt(waterStatusBox.length - 1, waterStatusData);
      return 0;
    } else {
      return drinkWaterGoal - amountOfWaterDrank;
    }
  }

  @override
  Widget build(BuildContext context) {
    var waterStatusData = waterStatusBox.getAt(waterStatusBox.length - 1);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                                "${waterStatusData!.amountOfWaterDrank}",
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
                              "${waterStatusData!.amountOfWaterDrank}",
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
              waterStatusData = WaterStatus(
                statusDay: waterStatusData!.statusDay,
                goalOfTheDayWasBeat: waterStatusData!.goalOfTheDayWasBeat,
                amountOfWaterDrank: waterStatusData!.amountOfWaterDrank += 200,
                drinkingWaterGoal: waterStatusData!.drinkingWaterGoal,
                drinkingFrequency: waterStatusData!.drinkingFrequency + 1,
              );
              waterStatusBox.putAt(waterStatusBox.length - 1, waterStatusData!);
              setState(() {});
              _howMuchIsMissing();
            },
          ),
          MyFabContent(
            myIconImageAsset: 'assets/images/garrafa.png',
            myFABContentText: '350ml',
            myFunction: () {
              waterStatusData = WaterStatus(
                statusDay: waterStatusData!.statusDay,
                goalOfTheDayWasBeat: waterStatusData!.goalOfTheDayWasBeat,
                amountOfWaterDrank: waterStatusData!.amountOfWaterDrank += 350,
                drinkingWaterGoal: waterStatusData!.drinkingWaterGoal,
                drinkingFrequency: waterStatusData!.drinkingFrequency + 1,
              );
              waterStatusBox.putAt(waterStatusBox.length - 1, waterStatusData!);
              setState(() {});
              _howMuchIsMissing();
            },
          ),
          MyFabContent(
            myIconImageAsset: 'assets/images/jarra.png',
            myFABContentText: '700ml',
            myFunction: () {
              waterStatusData = WaterStatus(
                statusDay: waterStatusData!.statusDay,
                goalOfTheDayWasBeat: waterStatusData!.goalOfTheDayWasBeat,
                amountOfWaterDrank: waterStatusData!.amountOfWaterDrank += 700,
                drinkingWaterGoal: waterStatusData!.drinkingWaterGoal,
                drinkingFrequency: waterStatusData!.drinkingFrequency + 1,
              );
              waterStatusBox.putAt(waterStatusBox.length - 1, waterStatusData!);
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
                Navigator.pushNamed(context, '/myStatusScreen',
                    arguments: _currentIndex);
                break;
              }
            case 2:
              {
                Navigator.pushNamed(context, '/mySettingsScreen',
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
              Icons.event_available,
              color: kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.settings,
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
