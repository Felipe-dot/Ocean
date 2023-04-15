import 'package:drinkwater/models/waterHistory.dart';

import '../models/userData.dart';

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
