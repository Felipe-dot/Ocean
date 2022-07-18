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

  User({
    required this.userWeight,
    required this.userWakeUpTime,
    required this.userSleepTime,
  });
}
