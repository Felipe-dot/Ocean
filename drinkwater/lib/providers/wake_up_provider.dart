import 'package:flutter/material.dart';

class WakeUp with ChangeNotifier {
  late TimeOfDay _wakeUpTime;

  TimeOfDay get wakeUpTime => _wakeUpTime;

  void add(TimeOfDay myWakeUpTime) {
    _wakeUpTime = myWakeUpTime;
    // ignore: avoid_print
    print("EU ACORDO ÀS $_wakeUpTime");
    notifyListeners();
  }
}
