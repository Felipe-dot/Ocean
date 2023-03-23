import 'package:drinkwater/components/buttons/my_cta_with_icon_right.dart';
import 'package:drinkwater/constant.dart';
import 'package:drinkwater/models/status.dart';
import 'package:drinkwater/models/user.dart';
import 'package:drinkwater/providers/sleep_time_provider.dart';
import 'package:drinkwater/providers/wake_up_provider.dart';
import 'package:drinkwater/providers/weight_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

import '../data/remote/api.dart';
import '../utils/user_token_storage.dart';

class MyIntroConclusionScreen extends StatefulWidget {
  const MyIntroConclusionScreen({Key? key}) : super(key: key);

  @override
  State<MyIntroConclusionScreen> createState() =>
      _MyIntroConclusionScreenState();
}

class _MyIntroConclusionScreenState extends State<MyIntroConclusionScreen> {
  late Box<User> userBox;
  late Box<WaterStatus> waterStatusBox;
  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    userBox = Hive.box('userBox');
    waterStatusBox = Hive.box('statusBox');
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  int howMuchINeedToDrink() {
    int myWeight = context.read<Weight>().weight;
    // Calculando quanto o usuário deve beber
    return myWeight * 35;
  }

  double thisIsEquivalentTo() {
    int drinkGoal = howMuchINeedToDrink();
    return drinkGoal / 200;
  }

  List<DateTime> _notificationTimeList() {
    final now = DateTime.now();
    var wakeUpTimeOfDay = context.read<WakeUp>().wakeUpTime;
    var sleepTimeOfDay = context.read<Sleep>().sleepTime;

    DateTime wakeUpTime = DateTime(
      now.year,
      now.month,
      now.day,
      wakeUpTimeOfDay.hour,
      wakeUpTimeOfDay.minute,
    );

    DateTime sleepTime = DateTime(
      now.year,
      now.month,
      now.day,
      sleepTimeOfDay.hour,
      sleepTimeOfDay.minute,
    );

    List<DateTime> notificationTimeList = [];
    notificationTimeList.add(wakeUpTime);

    var awakeTime = -1 * (wakeUpTime.difference(sleepTime).inHours);

    for (int x = 0; x < awakeTime; x++) {
      var timeModified =
          notificationTimeList[x].add(const Duration(hours: 1, minutes: 30));
      if (sleepTime.compareTo(timeModified) != 1) {
        break;
      }
      notificationTimeList.add(timeModified);
    }
    notificationTimeList.add(sleepTime);

    return notificationTimeList;
  }

  void _addDataToUserBox(
      int userWeight, DateTime userWakeUpTime, DateTime userSleepTime) async {
    userBox.add(
      User(
        userWeight: userWeight,
        userWakeUpTime: userWakeUpTime,
        userSleepTime: userSleepTime,
        additionalReminder: false,
        notificationTimeList: _notificationTimeList(),
      ),
    );

    waterStatusBox.add(WaterStatus(
      drinkingWaterGoal: howMuchINeedToDrink(),
      amountOfWaterDrank: 0,
      goalOfTheDayWasBeat: false,
      statusDay: DateTime.now(),
      drinkingFrequency: 0,
    ));

    // ignore: avoid_print
    print('User data added to box!');
  }

  void _addDataOnParseServer(
      int userWeight, DateTime userWakeUpTime, DateTime userSleepTime) async {
    Api api = Api();
    var token = await UserTokenSecureStorage.getUserToken();

    var response = await api.createUserData(token, howMuchINeedToDrink(),
        userWakeUpTime, userSleepTime, userWeight, _notificationTimeList());

    // print("OLA MEUS DADOS $response");
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    var wakeUpTime = context.read<WakeUp>().wakeUpTime;
    var sleepTime = context.read<Sleep>().sleepTime;
    var userWeight = context.read<Weight>().weight;

    DateTime userWakeUpTime = DateTime(
      now.year,
      now.month,
      now.day,
      wakeUpTime.hour,
      wakeUpTime.minute,
    );

    DateTime userSleepTime = DateTime(
      now.year,
      now.month,
      now.day,
      sleepTime.hour,
      sleepTime.minute,
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 30, bottom: 60),
          color: kMainColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Image(
                image: AssetImage('assets/images/logoSplashScreen.png'),
                height: 89,
                width: 145,
              ),
              Text(
                'Pronto! já calculamos tudo',
                style: kHeadline5.copyWith(color: kWhite),
              ),
              const Image(
                image: AssetImage('assets/images/metaCalculada.png'),
                height: 112,
                width: 99,
              ),
              Text(
                'Sua meta de ingestão de água diaria é',
                style: kHeadline6.copyWith(color: kLightBlue3),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${howMuchINeedToDrink()}',
                    style: kHeadline1.copyWith(color: kWhite),
                  ),
                  Text('ml', style: kCaption.copyWith(color: kWhite)),
                ],
              ),
              SizedBox(
                height: 45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'isso é equivalente a:',
                      style: kSubtitle1.copyWith(color: kLightBlue2),
                    ),
                    SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${thisIsEquivalentTo().toStringAsFixed(0)} copos de 200ml',
                            style: kHeadline6.copyWith(color: kLightBlue3),
                          ),
                          const Image(
                            image: AssetImage('assets/images/copoWhite.png'),
                            height: 20,
                            width: 18,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: MyCtaWithIconRight(
                  background: kWhite,
                  textStyle: kButton.copyWith(color: kMainColor),
                  function: () async {
                    // Navigator.pushNamed(context, '/myHomePage');
                    Navigator.pushNamed(context, '/myHomePage');
                    _addDataToUserBox(
                        userWeight, userWakeUpTime, userSleepTime);
                    _addDataOnParseServer(
                        userWeight, userWakeUpTime, userSleepTime);
                    print("FIM-----------------");
                  },
                  height: 70,
                  width: 280,
                  icon: Icons.arrow_right_alt_outlined,
                  text: 'Continuar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
