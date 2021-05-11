import 'package:flutter/cupertino.dart';
import 'package:perudo/models/bet.dart';
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

  Player getPlayer(String id) {
    return game.getPlayer(id);
  }

  bool makeBet(Bet newBet) {
    bool result = game.makeBet(newBet);
    notifyListeners();
    return result;
  }

  void nextPlayer() {
    game.nextPlayer();
    notifyListeners();
  }

  void removePlayer(String playerId) {
    game.removePlayer(playerId);
    notifyListeners();
  }

  void start(int diceNumber) {
    game.startDiceNumber = diceNumber;
    game.currentPlayer = game.players[0];
    game.rollDiceForEveryone();
    notifyListeners();
  }

  void startNewRound() {
    game.startNewRound();
  }

  void setGame(Game game) {
    this.game = game;
  }

  void setPlayerName(String userId, String name) {
    game.players.where((player) => player.id == userId).first.name = name;
    notifyListeners();
  }

  void setPlayerReady(String userId, bool ready) {
    game.players.where((player) => player.id == userId).first.ready = ready;
    notifyListeners();
  }

  void setCurrentBet(Bet bet) {
    game.setCurrentBet(bet);
    notifyListeners();
  }

  int getDiceCount() {
    var result = 0;
    for (var player in game.players) {
      result += player.diceCount!;
    }
    return result;
  }

  void setDiceNumber(Player player, int diceNumber) {
    game.players.where((element) => element.id == player.id).first.diceCount = diceNumber;
    if (diceNumber == 0) {
      removePlayer(player.id!);
    }
    notifyListeners();
  }

  Player lie(Player player) {
    var playerName = game.lie(player);
    notifyListeners();
    return playerName;
  }
}
