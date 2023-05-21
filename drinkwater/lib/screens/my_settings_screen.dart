import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:drinkwater/components/my_number_picker.dart';
import 'package:drinkwater/components/my_time_picker.dart';
import 'package:drinkwater/models/status.dart';
import 'package:drinkwater/models/user.dart';
import 'package:drinkwater/providers/sleep_time_provider.dart';
import 'package:drinkwater/providers/wake_up_provider.dart';
import 'package:drinkwater/providers/weight_provider.dart';
import 'package:drinkwater/utils/user_id_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import '../constant.dart';
import '../data/remote/api.dart';
import '../utils/my_utils.dart';
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

  bool showUserId = false;
  String userId = "";

  @override
  Widget build(BuildContext context) {
    var waterStatusData = waterStatusBox.getAt(waterStatusBox.length - 1);
    var userData = userBox.getAt(userBox.length - 1);

    Api api = Api();

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
                    onPressed: () async {
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

                      var token = await UserTokenSecureStorage.getUserToken();
                      await api.changeWaterIntakeGoal(
                          token, auxWaterGoal.round());
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

    void getUserId() async {
      var response = await UserIdSecureStorage.getUserId();
      setState(() {
        showUserId = !showUserId;
        userId = response as String;
      });
    }

    void clearUserData() async {
      final storage = new FlutterSecureStorage();
      await storage.deleteAll();
      userBox.clear();
      waterStatusBox.clear();
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
                  // padding: const EdgeInsets.only(left: 35),
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
                    onPressed: () async {
                      userData = User(
                        userWeight: context.read<Weight>().weight,
                        userWakeUpTime: userData!.userWakeUpTime,
                        userSleepTime: userData!.userSleepTime,
                        additionalReminder: userData!.additionalReminder,
                        notificationTimeList: userData!.notificationTimeList,
                      );
                      userBox.putAt(userBox.length - 1, userData!);

                      Navigator.of(context).pop(context);

                      var token = await UserTokenSecureStorage.getUserToken();
                      await api.changeUserWeight(
                          token, context.read<Weight>().weight);
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
                    onPressed: () async {
                      var wakeTimeHour = context.read<WakeUp>().wakeUpTime.hour;
                      var wakeTimeMinute =
                          context.read<WakeUp>().wakeUpTime.minute;
                      var sleepTimeHour = context.read<Sleep>().sleepTime.hour;
                      var sleepTimeMinute =
                          context.read<Sleep>().sleepTime.minute;

                      var notificationTimeList = createNotificationTimeList(
                          wakeTimeHour,
                          wakeTimeMinute,
                          sleepTimeHour,
                          sleepTimeMinute);

                      await cancelAllSchedules();

                      createNotificationWaterAlarms(notificationTimeList);
                      DateTime userWakeUpTime = DateTime(
                        userData!.userWakeUpTime.year,
                        userData!.userWakeUpTime.month,
                        userData!.userWakeUpTime.day,
                        context.read<WakeUp>().wakeUpTime.hour,
                        context.read<WakeUp>().wakeUpTime.minute,
                      );
                      userData = User(
                        userWeight: userData!.userWeight,
                        userWakeUpTime: userWakeUpTime,
                        userSleepTime: userData!.userSleepTime,
                        additionalReminder: userData!.additionalReminder,
                        notificationTimeList: notificationTimeList,
                      );
                      userBox.putAt(userBox.length - 1, userData!);
                      Navigator.of(context).pop(context);

                      var token = await UserTokenSecureStorage.getUserToken();
                      await api.changeWakeUpTime(
                          token, userWakeUpTime.toIso8601String());
                      await api.changeNotificationTimeList(
                          token, notificationTimeList);
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
                    onPressed: () async {
                      var wakeTimeHour = context.read<WakeUp>().wakeUpTime.hour;
                      var wakeTimeMinute =
                          context.read<WakeUp>().wakeUpTime.minute;
                      var sleepTimeHour = context.read<Sleep>().sleepTime.hour;
                      var sleepTimeMinute =
                          context.read<Sleep>().sleepTime.minute;
                      var notificationTimeList = createNotificationTimeList(
                          wakeTimeHour,
                          wakeTimeMinute,
                          sleepTimeHour,
                          sleepTimeMinute);

                      await cancelAllSchedules();
                      createNotificationWaterAlarms(notificationTimeList);

                      DateTime userSleepTime = DateTime(
                        userData!.userSleepTime.year,
                        userData!.userSleepTime.month,
                        userData!.userSleepTime.day,
                        context.read<Sleep>().sleepTime.hour,
                        context.read<Sleep>().sleepTime.minute,
                      );
                      userData = User(
                          userWeight: userData!.userWeight,
                          userWakeUpTime: userData!.userWakeUpTime,
                          userSleepTime: userSleepTime,
                          additionalReminder: userData!.additionalReminder,
                          notificationTimeList: notificationTimeList);
                      userBox.putAt(userBox.length - 1, userData!);

                      Navigator.of(context).pop(context);
                      var token = await UserTokenSecureStorage.getUserToken();
                      await api.changeSleepTime(
                          token, userSleepTime.toIso8601String());
                      await api.changeNotificationTimeList(
                          token, notificationTimeList);
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
                title: const Text(
                  "Id do usuário",
                  style: TextStyle(color: kMainColor),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      showUserId ? userId : "**********",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kMainColor,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          getUserId();
                          if (!showUserId) {
                            Clipboard.setData(ClipboardData(text: userId))
                                .then((result) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Copiado para área de transferência !')));
                            });
                          }
                        },
                        icon: showUserId
                            ? Icon(
                                Icons.visibility_off,
                                color: kMainColor,
                              )
                            : Icon(
                                Icons.visibility,
                                color: kMainColor,
                              ))
                  ],
                ),
              ),
              ListTile(
                title: const Text(
                  "Meta de ingestão",
                  style: TextStyle(color: kMainColor),
                ),
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
                  title: const Text(
                    "Peso",
                    style: TextStyle(color: kMainColor),
                  ),
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
                  title: const Text(
                    "Hora de acordar",
                    style: TextStyle(color: kMainColor),
                  ),
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
                  title: const Text(
                    "Hora de dormir",
                    style: TextStyle(color: kMainColor),
                  ),
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
                onTap: () async {
                  doUserLogout();
                  clearUserData();
                  await cancelAllSchedules();

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
