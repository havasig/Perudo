import 'package:json_annotation/json_annotation.dart';
import 'package:perudo/models/game.dart';
import 'package:perudo/models/player.dart';

import 'bet.dart';

part 'json_models.g.dart';

@JsonSerializable()
class GameDTO {
  int id;
  int startDiceNumber;
  List<PlayerDTO> players;
  bool turn;
  BetDTO? currentBet;
  PlayerDTO currentPlayer;

  GameDTO(this.id, this.startDiceNumber, this.players, this.turn, this.currentBet, this.currentPlayer);

  factory GameDTO.fromJson(Map<String, dynamic> json) => _$GameDTOFromJson(json);
  Map<String, dynamic> toJson() => _$GameDTOToJson(this);

  Game toGame() {
    List<Player> players = this.players.map((player) => player.toPlayer()).toList();
    Game game = Game(currentPlayer.toPlayer(), players);
    game.id = id;
    game.startDiceNumber = startDiceNumber;
    game.turn = turn;
    game.currentBet = currentBet?.toBet();
    return game;
  }
}

@JsonSerializable()
class PlayerDTO {
  String id;
  bool ready;
  List<int> diceValues;
  String name;
  bool isAdmin;

  PlayerDTO(this.id, this.ready, this.diceValues, this.name, this.isAdmin);

  factory PlayerDTO.fromJson(Map<String, dynamic> json) => _$PlayerDTOFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerDTOToJson(this);

  Player toPlayer() {
    var player = Player(isAdmin);
    player.id = id;
    player.ready = ready;
    player.diceValues = diceValues;
    player.name = name;
    return player;
  }
}

@JsonSerializable()
class BetDTO {
  int value;
  int count;
  PlayerDTO player;

  BetDTO(this.value, this.count, this.player);

  factory BetDTO.fromJson(Map<String, dynamic> json) => _$BetDTOFromJson(json);
  Map<String, dynamic> toJson() => _$BetDTOToJson(this);

  Bet toBet() {
    return Bet(value, count, player.toPlayer());
  }
}

@JsonSerializable()
class MessageDTO {
  String messageType;
  String? userId;
  dynamic object;

  MessageDTO(this.messageType, this.userId, this.object);

  factory MessageDTO.fromJson(Map<String, dynamic> json) => _$MessageDTOFromJson(json);
  Map<String, dynamic> toJson() => _$MessageDTOToJson(this);
}
