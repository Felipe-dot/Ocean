import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final int userWeight;

  @HiveField(1)
  final DateTime userWakeUpTime;

  @HiveField(2)
  final DateTime userSleepTime;

  @HiveField(3)
  final bool additionalReminder;

  @HiveField(4)
  final List<DateTime> notificationTimeList;

  User({
    required this.userWeight,
    required this.userWakeUpTime,
    required this.userSleepTime,
    required this.additionalReminder,
    required this.notificationTimeList,
  });
}
