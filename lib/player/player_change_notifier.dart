import 'package:flutter/cupertino.dart';

import 'player.dart';

class PlayerChangeNotifier extends ChangeNotifier {
  late Player player;

  void setName(String name) {
    player.name = name;
    notifyListeners();
  }

  void setReady(bool ready) {
    player.ready = ready;
    notifyListeners();
  }

  void setPlayer(Player me) {
    player = me;
  }
}
