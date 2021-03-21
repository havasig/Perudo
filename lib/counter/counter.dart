import 'package:flutter/cupertino.dart';

class Counter extends ChangeNotifier {
  int count = 1;

  void incrementCounter() {
    count++;
    notifyListeners();
  }

  void decrementCounter() {
    if (count == 1) return;
    count--;
    notifyListeners();
  }
}
