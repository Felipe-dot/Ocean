import 'package:hive/hive.dart';

part 'status.g.dart';

@HiveType(typeId: 2)
class WaterStatus {
  @HiveField(3)
  int drinkingWaterGoal;

  @HiveField(4)
  bool goalOfTheDayWasBeat;

  @HiveField(5)
  int amountOfWaterDrank;

  @HiveField(6)
  DateTime statusDay;

  @HiveField(7)
  List<WaterStatus> waterStatusData;

  WaterStatus({
    this.drinkingWaterGoal,
    this.amountOfWaterDrank,
    this.goalOfTheDayWasBeat,
    this.statusDay,
    this.waterStatusData,
  });
}
