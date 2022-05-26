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

class MyIntroConclusionScreen extends StatefulWidget {
  const MyIntroConclusionScreen({Key key}) : super(key: key);

  @override
  State<MyIntroConclusionScreen> createState() =>
      _MyIntroConclusionScreenState();
}

class _MyIntroConclusionScreenState extends State<MyIntroConclusionScreen> {
  Box<User> userBox;
  Box<WaterStatus> waterStatusBox;
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

  void _addDataToUserBox() async {
    final now = DateTime.now();
    var wakeUpTime = context.read<WakeUp>().wakeUpTime;
    var sleepTime = context.read<Sleep>().sleepTime;

    userBox.add(User(
        userWeight: context.read<Weight>().weight,
        userWakeUpTime: DateTime(
          now.year,
          now.month,
          now.day,
          wakeUpTime.hour,
          wakeUpTime.minute,
        ),
        userSleepTime: DateTime(
          now.year,
          now.month,
          now.day,
          sleepTime.hour,
          sleepTime.minute,
        )));

    waterStatusBox.add(WaterStatus(
      drinkingWaterGoal: howMuchINeedToDrink(),
      amountOfWaterDrank: 0,
      goalOfTheDayWasBeat: false,
      statusDay: DateTime.now(),
    ));

    // ignore: avoid_print
    print('User data added to box!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 30, bottom: 60),
          color: kMainColor,
          child: Expanded(
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
                    function: () {
                      // Navigator.pushNamed(context, '/myHomePage');
                      Navigator.pushNamed(context, '/myHomePage');
                      _addDataToUserBox();
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
      ),
    );
  }
}
