import 'package:flutter/material.dart';

class Weight with ChangeNotifier {
  int _weight = 55;

  int get weight => _weight;

  void add(int myWeight) {
    _weight = myWeight;
    // ignore: avoid_print
    print("MEU PESO É $_weight");
    notifyListeners();
  }
}
