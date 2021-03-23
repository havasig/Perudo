import 'package:flutter/cupertino.dart';

class BetCreateChangeNotifier extends ChangeNotifier {
  int count = 1;
  int value = 1;

  void incrementCount() {
    count++;
    notifyListeners();
  }

  void decrementCount() {
    if (count == 1) return;
    count--;
    notifyListeners();
  }

  void incrementValue() {
    if (value == 6) return;
    value++;
    notifyListeners();
  }

  void decrementValue() {
    if (value == 1) return;
    value--;
    notifyListeners();
  }
}
