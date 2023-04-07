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
