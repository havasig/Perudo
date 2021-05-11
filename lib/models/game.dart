import 'dart:math';

import 'package:perudo/models/bet.dart';
import 'package:perudo/models/json_models.dart';
import 'package:perudo/models/player.dart';

class Game {
  int id = 0;
  int startDiceNumber = 5;
  List<Player> players = [];
  bool turn = false;
  Bet? currentBet;
  late Player currentPlayer;
  bool startNewGame = false;

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

  void nextPlayer() {
    final playersMap = players.asMap();
    var currentPlayerPosition = playersMap.keys.firstWhere((value) => playersMap[value]!.id == currentPlayer.id);
    var nextPlayerPosition = currentPlayerPosition + 1;
    if (playersMap.length == nextPlayerPosition) nextPlayerPosition = 0;
    currentPlayer = playersMap[nextPlayerPosition]!;
  }

  bool makeBet(Bet newBet) {
    var isBigger = _isBigger(newBet);
    if (isBigger) currentBet = newBet;
    return isBigger;
  }

  _isBigger(Bet myBet) {
    if (currentBet == null) return true;
    int currentBetValue = (currentBet!.count * 10) + currentBet!.value;
    int myBetValue = (myBet.count * 10) + myBet.value;
    if (myBet.value == 1 && currentBet!.value == 1) {
      return myBetValue > currentBetValue;
    } else if (myBet.value == 1 && currentBet!.value != 1) {
      return myBetValue * 2 > currentBetValue;
    } else if (myBet.value != 1 && currentBet!.value == 1) {
      return myBetValue >= currentBetValue * 2;
    } else {
      return myBetValue > currentBetValue;
    }
  }

  void setCurrentBet(Bet bet) {
    currentBet = bet;
  }

  void removePlayer(String playerId) {
    Player? leavingPlayer = players.where((player) => player.id == playerId).first;
    players.remove(leavingPlayer);
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
      player.diceCount = startDiceNumber;
      for (var i = 0; i < startDiceNumber; i++) {
        player.diceValues!.add(rnd.nextInt(6) + 1);
      }
    }
  }

  void startNewRound() {
    var rnd = new Random();
    for (var player in players) {
      player.diceValues = [];
      for (var i = 0; i < player.diceCount!; i++) {
        player.diceValues!.add(rnd.nextInt(6) + 1);
      }
    }
  }

  GameDTO toDTO() {
    List<PlayerDTO> players = this.players.map((player) => player.toDTO()).toList();
    return GameDTO(id, startDiceNumber, players, turn, currentBet?.toDTO(), currentPlayer.toDTO());
  }

  Player getPlayer(String id) {
    return players.where((player) => player.id == id).first;
  }

  Player lie(Player player) {
    var numberOfDice = this.numberOf(currentBet!.value);
    late Player looser;
    late Player winner;
    if (numberOfDice >= currentBet!.count) {
      looser = players.where((p) => p.id == player.id).first;
      winner = players.where((p) => p.id == currentBet!.player.id).first;
    } else {
      winner = players.where((p) => p.id == player.id).first;
      looser = players.where((p) => p.id == currentBet!.player.id).first;
    }
    looser.looseDice();
    currentBet = null;
    if (looser.diceCount! > 0) {
      currentPlayer = looser;
    } else {
      this.players.remove(looser);
      currentPlayer = winner;
    }
    return looser;
  }

  int numberOf(int diceValue) {
    var numberOfDice = 0;
    for (var player in players) {
      for (var dice in player.diceValues!) {
        if (dice == diceValue || dice == 1) numberOfDice++;
      }
    }
    return numberOfDice;
  }
}
