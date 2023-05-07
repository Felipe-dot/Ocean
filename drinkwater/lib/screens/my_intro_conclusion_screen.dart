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
import '../utils/my_utils.dart';
import '../utils/user_token_storage.dart';
import '../utils/water_id_storage.dart';

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

  double thisIsEquivalentTo() {
    int drinkGoal = howMuchINeedToDrink(context.read<Weight>().weight);
    return drinkGoal / 200;
  }

  void _addDataToUserBox(
      int userWeight, DateTime userWakeUpTime, DateTime userSleepTime) async {
    var wakeTimeHour = context.read<WakeUp>().wakeUpTime.hour;
    var wakeTimeMinute = context.read<WakeUp>().wakeUpTime.minute;
    var sleepTimeHour = context.read<Sleep>().sleepTime.hour;
    var sleepTimeMinute = context.read<Sleep>().sleepTime.minute;

    userBox.add(
      User(
        userWeight: userWeight,
        userWakeUpTime: userWakeUpTime,
        userSleepTime: userSleepTime,
        additionalReminder: false,
        notificationTimeList: createNotificationTimeList(
          wakeTimeHour,
          wakeTimeMinute,
          sleepTimeHour,
          sleepTimeMinute,
        ),
      ),
    );

    waterStatusBox.add(WaterStatus(
      drinkingWaterGoal: howMuchINeedToDrink(context.read<Weight>().weight),
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
    var wakeTimeHour = context.read<WakeUp>().wakeUpTime.hour;
    var wakeTimeMinute = context.read<WakeUp>().wakeUpTime.minute;
    var sleepTimeHour = context.read<Sleep>().sleepTime.hour;
    var sleepTimeMinute = context.read<Sleep>().sleepTime.minute;

    Api api = Api();
    var token = await UserTokenSecureStorage.getUserToken();

    var response = await api.createUserData(
        token,
        howMuchINeedToDrink(context.read<Weight>().weight),
        userWakeUpTime,
        userSleepTime,
        userWeight,
        createNotificationTimeList(
          wakeTimeHour,
          wakeTimeMinute,
          sleepTimeHour,
          sleepTimeMinute,
        ));
  }

  void _addWaterHistoryOnParseServer(
      DateTime statusDay,
      bool goalOfTheDayWasBeat,
      int amountOfWaterDrank,
      int drinkingFrequency) async {
    Api api = Api();
    var token = await UserTokenSecureStorage.getUserToken();

    var response = await api.createWaterHistory(
      token,
      statusDay,
      goalOfTheDayWasBeat,
      amountOfWaterDrank,
      drinkingFrequency,
    );

    await WaterIdSecureStorage.setWaterIdString(response['result']);
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
                    '${howMuchINeedToDrink(context.read<Weight>().weight)}',
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
                    _addWaterHistoryOnParseServer(
                      DateTime.now(),
                      false,
                      0,
                      0,
                    );
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
