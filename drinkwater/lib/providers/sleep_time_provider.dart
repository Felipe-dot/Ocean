import 'package:flutter/material.dart';

class Sleep with ChangeNotifier {
  TimeOfDay _sleepTime;

  TimeOfDay get sleepTime => _sleepTime;

  void add(TimeOfDay mySleepTime) {
    _sleepTime = mySleepTime;
    print("EU DURMO ÀS ${_sleepTime}");
    notifyListeners();
  }
  
}
