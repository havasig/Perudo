import 'dart:math';

import 'package:perudo/models/bet.dart';
import 'package:perudo/models/player.dart';

class Game {
  int id = 0;
  int startDiceNumber = 5;
  List<Player> players = [];
  bool turn = false;
  Bet? currentBet;
  late Player currentPlayer;

  Game(
    this.currentPlayer,
    this.players, [
    this.id = 0,
    this.startDiceNumber = 5,
    this.turn = false,
    this.currentBet,
  ]);

  void addPlayer(Player player) {
    players.add(player);
  }

  bool everyPlayerReady() {
    for (var player in players) {
      if (!player.ready) return false;
    }
    return true;
  }

  void rollDiceForEveryone() {
    var rnd = new Random();
    for (var player in players) {
      for (var i = 0; i < startDiceNumber; i++) {
        player.diceValues!.add(rnd.nextInt(6) + 1);
      }
    }
  }
}
