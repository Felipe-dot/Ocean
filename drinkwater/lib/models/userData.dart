class UserData {
  String id;
  int waterIntakeGoal;
  int userWeight;
  DateTime wakeUpTime;
  DateTime sleepTime;
  List<DateTime> notificationTimeList;

  UserData({
    required this.id,
    required this.waterIntakeGoal,
    required this.userWeight,
    required this.wakeUpTime,
    required this.sleepTime,
    required this.notificationTimeList,
  });
}
