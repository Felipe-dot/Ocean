import 'package:flutter/material.dart';

class Sleep with ChangeNotifier {
  late TimeOfDay _sleepTime;

  TimeOfDay get sleepTime => _sleepTime;

  void add(TimeOfDay mySleepTime) {
    _sleepTime = mySleepTime;
    // ignore: avoid_print
    print("EU DURMO ÀS $_sleepTime");
    notifyListeners();
  }
}
