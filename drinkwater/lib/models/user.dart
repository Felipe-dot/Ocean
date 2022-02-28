import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final int drinkingWaterGoal;

  @HiveField(1)
  final int userWeight;

  @HiveField(2)
  final DateTime userWakeUpTime;

  @HiveField(3)
  final DateTime userSleepTime;

  @HiveField(4)
  final Map<DateTime, bool> goalOfTheDayBeat;

  @HiveField(5)
  final int drinkingWaterStatus;

  User({
    this.drinkingWaterGoal,
    this.userWeight,
    this.userWakeUpTime,
    this.userSleepTime,
    this.goalOfTheDayBeat,
    this.drinkingWaterStatus,
  });
}
