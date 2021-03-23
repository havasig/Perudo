import 'package:flutter/cupertino.dart';

class DiceCounterChangeNotifier extends ChangeNotifier {
  int count = 5;

  void incrementCounter() {
    count++;
    notifyListeners();
  }

  void decrementCounter() {
    if (count == 1) return;
    count--;
    //Http post ?
    notifyListeners();
  }
}
