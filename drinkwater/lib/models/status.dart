import 'package:hive/hive.dart';

part 'status.g.dart';

@HiveType(typeId: 2)
class WaterStatus {
  @HiveField(0)
  int drinkingWaterGoal;

  @HiveField(1)
  bool goalOfTheDayWasBeat;

  @HiveField(2)
  int amountOfWaterDrank;

  @HiveField(3)
  int drinkingFrequency;

  @HiveField(4)
  DateTime statusDay;

  WaterStatus({
    required this.drinkingWaterGoal,
    required this.amountOfWaterDrank,
    required this.goalOfTheDayWasBeat,
    required this.statusDay,
    required this.drinkingFrequency,
  });
}
