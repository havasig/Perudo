import 'package:flutter/cupertino.dart';
import 'package:perudo/game/game.dart';
import 'package:perudo/player/player.dart';

class GameChangeNotifier extends ChangeNotifier {
  Game game;
  GameChangeNotifier(this.game);

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

  void rollDiceForEveryone() {
    //TODO
  }

  bool everyPlayerReady() {
    //TODO
    return true;
  }

  void addPlayer(Player player) {
    game.addPlayer(player);
    notifyListeners();
  }
}
