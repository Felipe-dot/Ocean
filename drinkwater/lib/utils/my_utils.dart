import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:drinkwater/models/waterHistory.dart';
import 'package:drinkwater/utils/user_token_storage.dart';
import 'package:drinkwater/utils/water_id_storage.dart';
import 'package:hive/hive.dart';

import '../constant.dart';
import '../data/remote/api.dart';
import '../models/status.dart';
import '../models/userData.dart';
import '../services/notification_service.dart';

List<DateTime> createNotificationTimeList(
  int wakeTimeHour,
  int wakeTimeMinute,
  int sleepTimeHour,
  int sleepTimeMinute,
) {
  final now = DateTime.now();
  var wakeUpTime = DateTime(
    now.year,
    now.month,
    now.day,
    wakeTimeHour,
    wakeTimeMinute,
  );

  var sleepTime = DateTime(
    now.year,
    now.month,
    now.day,
    sleepTimeHour,
    sleepTimeMinute,
  );

  List<DateTime> notificationTimeList = [];
  notificationTimeList.add(wakeUpTime);

  var awakeTime = -1 * (wakeUpTime.difference(sleepTime).inHours);

  for (int x = 0; x < awakeTime; x++) {
    var timeModified = notificationTimeList[x].add(const Duration(minutes: 50));
    if (sleepTime.compareTo(timeModified) != 1) {
      break;
    }
    notificationTimeList.add(timeModified);
  }
  notificationTimeList.add(sleepTime);

  return notificationTimeList;
}

UserData createUserData(var user) {
  var notificationTimeListString = user['notificationTimeList'];
  List<DateTime> notificationTimeList = [];
  notificationTimeListString.forEach((e) {
    notificationTimeList.add(DateTime.parse(e));
  });

  return UserData(
    id: user['id'],
    waterIntakeGoal: user['waterIntakeGoal'],
    userWeight: user['userWeight'],
    wakeUpTime: DateTime.parse(user['wakeUpTime']),
    sleepTime: DateTime.parse(user['sleepTime']),
    notificationTimeList: notificationTimeList,
  );
}

List<WaterHistory> createAListOfWaterHistory(List<dynamic> waterHistory) {
  List<WaterHistory> waterHistoryList = [];
  waterHistory.forEach((element) {
    waterHistoryList.add(WaterHistory(
      id: element['id'],
      statusDay: DateTime.parse(element['statusDay']),
      goalOfTheDayWasBeat: element['goalOfTheDayWasBeat'],
      amountOfWaterDrank: element['amountOfWaterDrank'],
      drinkFrequency: element['drinkFrequency'],
    ));
  });

  return waterHistoryList;
}

int howMuchINeedToDrink(int myWeight) {
  // Calculando quanto o usuário deve beber
  return myWeight * 35;
}

Future<bool> isDayChanged(Box<WaterStatus> waterStatusBox) async {
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
    try {
      Api api = Api();
      final token = await UserTokenSecureStorage.getUserToken();
      var response = await api.createWaterHistory(
        token,
        DateTime.now(),
        false,
        0,
        0,
      );

      await WaterIdSecureStorage.setWaterIdString(response['result']);
    } catch (e) {
      print("MEU QUERIDO ERRO DE INSERCAO $e");
    }

    print("ONTEM = $lastDay ==== HOJE = ${DateTime.now().day}");
    return true;
  } else {
    print("HOJE = $lastDay ==== HOJE = ${DateTime.now().day}");
    return false;
  }
}

bool getGoalStatus(Box<WaterStatus> waterStatusBox) {
  return waterStatusBox.getAt(waterStatusBox.length - 1)!.goalOfTheDayWasBeat;
}

double percentageCalc(Box<WaterStatus> waterStatusBox) {
  var waterStatusData = waterStatusBox.getAt(waterStatusBox.length - 1);
  int amountOfWaterDrank = waterStatusData!.amountOfWaterDrank;
  int drinkWaterGoal = waterStatusData.drinkingWaterGoal;

  double percentage = (amountOfWaterDrank * 100) / drinkWaterGoal;

  // Aplicando regra de três
  return percentage > 100 ? 100 : percentage;
}

void updateAmountOfWaterDrank(
    Box<WaterStatus> waterStatusBox, int value, WaterStatus waterStatusData) {
  waterStatusData = WaterStatus(
    statusDay: waterStatusData.statusDay,
    goalOfTheDayWasBeat: waterStatusData.goalOfTheDayWasBeat,
    amountOfWaterDrank: waterStatusData.amountOfWaterDrank += value,
    drinkingWaterGoal: waterStatusData.drinkingWaterGoal,
    drinkingFrequency: waterStatusData.drinkingFrequency + 1,
  );
  waterStatusBox.putAt(waterStatusBox.length - 1, waterStatusData);
}

void updateWaterStatusOnParseServer(WaterStatus waterStatusData) async {
  Api api = Api();
  final token = await UserTokenSecureStorage.getUserToken();
  final waterId = await WaterIdSecureStorage.getWaterId();

  try {
    await api.changeAmountOfWaterDrank(
        token, waterId, waterStatusData.amountOfWaterDrank);
    await api.changeDrinkFrequency(
        token, waterId, waterStatusData.drinkingFrequency);
  } catch (e) {
    print("MEU ERRO $e");
  }
}

void updateGoalOfTheDayOnParseServer(WaterStatus waterStatusData) async {
  Api api = Api();
  final token = await UserTokenSecureStorage.getUserToken();
  final waterId = await WaterIdSecureStorage.getWaterId();
  try {
    await api.changeGoalOfTheDayWasBeat(
        token, waterId, waterStatusData.goalOfTheDayWasBeat);
  } catch (e) {
    print("MEU ERRO $e");
  }
}

int howMuchIsMissing(Box<WaterStatus> waterStatusBox) {
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
    updateGoalOfTheDayOnParseServer(waterStatusData);
    waterStatusBox.putAt(waterStatusBox.length - 1, waterStatusData);
    return 0;
  } else {
    return drinkWaterGoal - amountOfWaterDrank;
  }
}

Future<void> isNotificationAlreadyCreate() async {
  List<NotificationModel> scheduledNotifications =
      await AwesomeNotifications().listScheduledNotifications();

  scheduledNotifications.forEach((element) {
    print("MEU ELEMENTO ${element.schedule}");
  });
}

Future<void> cancelAllSchedules() async {
  await AwesomeNotifications().cancelAllSchedules();
}

void createNotificationWaterAlarms(List<DateTime>? notificationTimeList) async {
  print("========================");
  print(notificationTimeList);
  print("========================");
  notificationTimeList!.forEach((e) async {
    await NotificationService.showNotification(
        title: "Hidrate-se",
        body: "Lembre-se de consumir água",
        payload: {
          "navigate": "true",
        },
        notificationLayout: NotificationLayout.Default,
        scheduled: true,
        hour: e.hour,
        minute: e.minute,
        actionButtons: [
          NotificationActionButton(
            key: 'check',
            label: 'Registre seu consumo',
            actionType: ActionType.SilentAction,
            color: kDark1,
          )
        ]);
  });
}
