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
    this.drinkingWaterGoal,
    this.amountOfWaterDrank,
    this.goalOfTheDayWasBeat,
    this.statusDay,
    this.drinkingFrequency,
  });
}
