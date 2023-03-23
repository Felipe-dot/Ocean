import 'package:flutter/material.dart';

class Sleep with ChangeNotifier {
  TimeOfDay _sleepTime = const TimeOfDay(hour: 22, minute: 30);

  TimeOfDay get sleepTime => _sleepTime;

  void add(TimeOfDay mySleepTime) {
    _sleepTime = mySleepTime;
    // ignore: avoid_print
    print("EU DURMO ÀS $_sleepTime");
    notifyListeners();
  }
}
