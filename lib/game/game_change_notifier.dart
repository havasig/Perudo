import 'package:flutter/cupertino.dart';
import 'package:perudo/models/game.dart';
import 'package:perudo/models/player.dart';

class GameChangeNotifier extends ChangeNotifier {
  late Game game;

  bool everyPlayerReady() {
    return game.everyPlayerReady();
  }

  void addPlayer(Player player) {
    game.addPlayer(player);
    notifyListeners();
  }

  void start(int diceNumber) {
    game.startDiceNumber = diceNumber;
    game.currentPlayer = game.players[0];
    game.rollDiceForEveryone();
    notifyListeners();
  }

  void setGame(Game game) {
    this.game = game;
  }
}
