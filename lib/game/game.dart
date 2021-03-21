import 'package:flutter/cupertino.dart';
import 'package:perudo/player/player.dart';

class Game extends ChangeNotifier {
  int id = 0;
  List<Player> players = [];
  bool turn = false;
  Map<String, int> currentBet = {"count": 0, "value": 0};
  int currentPlayerId = 0;

  void addPlayer(Player player) {
    players.add(player);
  }
}
