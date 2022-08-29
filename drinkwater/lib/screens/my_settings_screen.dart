import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:drinkwater/components/my_number_picker.dart';
import 'package:drinkwater/components/my_time_picker.dart';
import 'package:drinkwater/models/status.dart';
import 'package:drinkwater/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../constant.dart';

class MySettings extends StatefulWidget {
  const MySettings({Key? key}) : super(key: key);

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
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

  bool temp = false;
  @override
  Widget build(BuildContext context) {
    var waterStatusData = waterStatusBox.getAt(waterStatusBox.length - 1);
    var userData = userBox.getAt(userBox.length - 1);

    final args = ModalRoute.of(context)!.settings.arguments;
    int? _currentIndex = args as int?;

    double auxWaterGoal = waterStatusData!.drinkingWaterGoal.roundToDouble();
    Future openWaterGoalDialog() => showDialog(
          context: context,
          builder: (context) => StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Center(child: Text("Alterar a meta de ingestão")),
              content: SizedBox(
                height: 100,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${auxWaterGoal.toStringAsFixed(0)} ml"),
                    Slider(
                      value: auxWaterGoal,
                      min: 1000,
                      max: 4500,
                      onChanged: (double newValue) {
                        setState(() {
                          auxWaterGoal = newValue.roundToDouble();
                        });
                      },
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(context);
                    },
                    child: const Text("CANCELAR")),
                TextButton(
                    onPressed: () {
                      waterStatusData = WaterStatus(
                        statusDay: waterStatusData!.statusDay,
                        goalOfTheDayWasBeat:
                            waterStatusData!.goalOfTheDayWasBeat,
                        amountOfWaterDrank: waterStatusData!.amountOfWaterDrank,
                        drinkingWaterGoal: auxWaterGoal.round(),
                        drinkingFrequency: waterStatusData!.drinkingFrequency,
                      );
                      waterStatusBox.putAt(
                          waterStatusBox.length - 1, waterStatusData!);
                      Navigator.of(context).pop(context);
                    },
                    child: const Text("OK")),
              ],
            );
          }),
        );

    Future openWeightDialog() => showDialog(
          context: context,
          builder: (context) => StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Center(child: Text("Alterar o seu peso")),
              content: SizedBox(
                height: 100,
                width: 100,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 35),
                  child: const MyNumberPicker(),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(context);
                    },
                    child: const Text("CANCELAR")),
                TextButton(onPressed: () {}, child: const Text("OK")),
              ],
            );
          }),
        );

    Future openWakeUpTimeDialog() => showDialog(
          context: context,
          builder: (context) => StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Center(child: Text("Alterar a hora de acordar")),
              content: const SizedBox(
                height: 100,
                width: 100,
                child: Center(child: MyTimePicker(isSleepTime: false)),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(context);
                    },
                    child: const Text("CANCELAR")),
                TextButton(onPressed: () {}, child: const Text("OK")),
              ],
            );
          }),
        );

    Future openSleepTimeDialog() => showDialog(
          context: context,
          builder: (context) => StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Center(child: Text("Alterar a hora de dormir")),
              content: const SizedBox(
                height: 100,
                width: 100,
                child: Center(child: MyTimePicker(isSleepTime: true)),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(context);
                    },
                    child: const Text("CANCELAR")),
                TextButton(onPressed: () {}, child: const Text("OK")),
              ],
            );
          }),
        );

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: kWhite,
          ),
          child: ListView(
            children: [
              const ListTile(
                title: Text("Agenda de notificações"),
                trailing: Icon(Icons.notifications),
              ),
              SwitchListTile(
                title: const Text("Lembrete adicional"),
                onChanged: (bool newValue) {
                  setState(() {
                    temp = newValue;
                    print(temp);
                  });
                },
                value: temp,
              ),
              ListTile(
                title: const Text("Meta de ingestão"),
                trailing: Text("${waterStatusData!.drinkingWaterGoal}ml"),
                onTap: () async {
                  await openWaterGoalDialog();
                  setState(() {});
                },
              ),
              ListTile(
                title: const Text("Peso"),
                trailing: Text("${userData!.userWeight} kg"),
                onTap: openWeightDialog,
              ),
              ListTile(
                title: const Text("Hora de acordar"),
                trailing: Text(DateFormat.Hm().format(userData.userWakeUpTime)),
                onTap: openWakeUpTimeDialog,
              ),
              ListTile(
                title: const Text("Hora de dormir"),
                trailing: Text(DateFormat.Hm().format(userData.userSleepTime)),
                onTap: openSleepTimeDialog,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        iconSize: 30,
        selectedIndex: _currentIndex!,
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
                Navigator.pushNamed(context, '/myStatusScreen',
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
