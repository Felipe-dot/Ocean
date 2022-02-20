import 'package:flutter/material.dart';

class WakeUp with ChangeNotifier {
  TimeOfDay _wakeUpTime;

  TimeOfDay get wakeUpTime => _wakeUpTime;

  void add(TimeOfDay myWakeUpTime) {
    _wakeUpTime = myWakeUpTime;
    print("EU ACORDO ÀS ${_wakeUpTime}");
    notifyListeners();
  }
}