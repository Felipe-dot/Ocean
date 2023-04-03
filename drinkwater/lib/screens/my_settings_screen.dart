import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:drinkwater/components/my_number_picker.dart';
import 'package:drinkwater/components/my_time_picker.dart';
import 'package:drinkwater/models/status.dart';
import 'package:drinkwater/models/user.dart';
import 'package:drinkwater/providers/sleep_time_provider.dart';
import 'package:drinkwater/providers/wake_up_provider.dart';
import 'package:drinkwater/providers/weight_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import '../constant.dart';
import '../data/remote/api.dart';
import '../utils/user_token_storage.dart';

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
  Widget build(BuildContext context) {
    var waterStatusData = waterStatusBox.getAt(waterStatusBox.length - 1);
    var userData = userBox.getAt(userBox.length - 1);

    final args = ModalRoute.of(context)!.settings.arguments;
    int? _currentIndex = args as int?;

    List<DateTime> _notificationTimeList() {
      final now = DateTime.now();
      var wakeUpTime = DateTime(
        now.year,
        now.month,
        now.day,
        context.read<WakeUp>().wakeUpTime.hour,
        context.read<WakeUp>().wakeUpTime.minute,
      );

      var sleepTime = DateTime(
        now.year,
        now.month,
        now.day,
        context.read<Sleep>().sleepTime.hour,
        context.read<Sleep>().sleepTime.minute,
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

    void doUserLogout() async {
      Api api = Api();

      var token = await UserTokenSecureStorage.getUserToken();

      await api.logout(token);
    }

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
                  child: MyNumberPicker(
                    currentValue: userData!.userWeight,
                  ),
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
                      userData = User(
                        userWeight: context.read<Weight>().weight,
                        userWakeUpTime: userData!.userWakeUpTime,
                        userSleepTime: userData!.userSleepTime,
                        additionalReminder: userData!.additionalReminder,
                        notificationTimeList: userData!.notificationTimeList,
                      );
                      userBox.putAt(userBox.length - 1, userData!);
                      Navigator.of(context).pop(context);
                    },
                    child: const Text("OK")),
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
              content: SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: MyTimePicker(
                    isSleepTime: false,
                    time: TimeOfDay(
                      hour: userData!.userWakeUpTime.hour,
                      minute: userData!.userWakeUpTime.minute,
                    ),
                  ),
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
                      userData = User(
                        userWeight: userData!.userWeight,
                        userWakeUpTime: DateTime(
                          userData!.userWakeUpTime.year,
                          userData!.userWakeUpTime.month,
                          userData!.userWakeUpTime.day,
                          context.read<WakeUp>().wakeUpTime.hour,
                          context.read<WakeUp>().wakeUpTime.minute,
                        ),
                        userSleepTime: userData!.userSleepTime,
                        additionalReminder: userData!.additionalReminder,
                        notificationTimeList: _notificationTimeList(),
                      );
                      userBox.putAt(userBox.length - 1, userData!);
                      Navigator.of(context).pop(context);
                    },
                    child: const Text("OK")),
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
              content: SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: MyTimePicker(
                    isSleepTime: true,
                    time: TimeOfDay(
                      hour: userData!.userSleepTime.hour,
                      minute: userData!.userSleepTime.minute,
                    ),
                  ),
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
                      userData = User(
                        userWeight: userData!.userWeight,
                        userWakeUpTime: userData!.userWakeUpTime,
                        userSleepTime: DateTime(
                          userData!.userSleepTime.year,
                          userData!.userSleepTime.month,
                          userData!.userSleepTime.day,
                          context.read<Sleep>().sleepTime.hour,
                          context.read<Sleep>().sleepTime.minute,
                        ),
                        additionalReminder: userData!.additionalReminder,
                        notificationTimeList: _notificationTimeList(),
                      );
                      userBox.putAt(userBox.length - 1, userData!);
                      Navigator.of(context).pop(context);
                    },
                    child: const Text("OK")),
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
              ListTile(
                title: const Text("Agenda de notificações"),
                trailing: const Icon(Icons.notifications),
                onTap: () => Navigator.pushNamed(
                    context, '/myNotificationSheduleScreen'),
              ),
              SwitchListTile(
                title: const Text("Lembrete adicional"),
                onChanged: (bool newValue) {
                  userData = User(
                    userWeight: userData!.userWeight,
                    userWakeUpTime: userData!.userWakeUpTime,
                    userSleepTime: userData!.userSleepTime,
                    additionalReminder: newValue,
                    notificationTimeList: userData!.notificationTimeList,
                  );
                  userBox.putAt(userBox.length - 1, userData!);
                  setState(() {});
                },
                value: userData!.additionalReminder,
              ),
              ListTile(
                title: const Text("Meta de ingestão"),
                trailing: Text(
                  "${waterStatusData!.drinkingWaterGoal}ml",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: kMainColor,
                  ),
                ),
                onTap: () async {
                  await openWaterGoalDialog();
                  setState(() {});
                },
              ),
              ListTile(
                  title: const Text("Peso"),
                  trailing: Text(
                    "${userData!.userWeight} kg",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: kMainColor,
                    ),
                  ),
                  onTap: () async {
                    await openWeightDialog();
                    setState(() {});
                  }),
              ListTile(
                  title: const Text("Hora de acordar"),
                  trailing: Text(
                    DateFormat.Hm().format(userData!.userWakeUpTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: kMainColor,
                    ),
                  ),
                  onTap: () async {
                    await openWakeUpTimeDialog();
                    setState(() {});
                  }),
              ListTile(
                  title: const Text("Hora de dormir"),
                  trailing: Text(
                    DateFormat.Hm().format(userData!.userSleepTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: kMainColor,
                    ),
                  ),
                  onTap: () async {
                    await openSleepTimeDialog();
                    setState(() {});
                  }),
              const Divider(),
              ListTile(
                title: const Text(
                  "Sair",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: kRedAccent,
                  ),
                ),
                onTap: () {
                  doUserLogout();
                  Navigator.pushNamed(context, '/myLoginScreen');
                },
              )
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
