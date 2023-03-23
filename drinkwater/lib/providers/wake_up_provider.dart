import 'package:flutter/material.dart';

class WakeUp with ChangeNotifier {
  TimeOfDay _wakeUpTime = const TimeOfDay(hour: 6, minute: 30);

  TimeOfDay get wakeUpTime => _wakeUpTime;

  void add(TimeOfDay myWakeUpTime) {
    _wakeUpTime = myWakeUpTime;
    print("EU ACORDO ÀS $_wakeUpTime");
    notifyListeners();
  }
}
