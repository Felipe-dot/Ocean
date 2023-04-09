class WaterHistory {
  String id;
  DateTime statusDay;
  bool goalOfTheDayWasBeat;
  int amountOfWaterDrank;
  int drinkFrequency;

  WaterHistory({
    required this.id,
    required this.statusDay,
    required this.goalOfTheDayWasBeat,
    required this.amountOfWaterDrank,
    required this.drinkFrequency,
  });
}
