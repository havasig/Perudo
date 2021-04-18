import 'package:json_annotation/json_annotation.dart';

part 'json_models.g.dart';

@JsonSerializable()
class GameResponse {
  final int id;
  final int startDiceNumber;
  final List<PlayerResponse> players;
  final bool turn;
  final BetResponse? currentBet;
  final PlayerResponse currentPlayer;

  GameResponse(this.id, this.startDiceNumber, this.players, this.turn,
      this.currentBet, this.currentPlayer);

  factory GameResponse.fromJson(Map<String, dynamic> json) =>
      _$GameResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GameResponseToJson(this);
}

@JsonSerializable()
class PlayerResponse {
  final int id;
  final bool ready;
  final List<int> diceValues;
  final String name;
  final bool isAdmin;

  PlayerResponse(this.id, this.ready, this.diceValues,this.name, this.isAdmin);

  factory PlayerResponse.fromJson(Map<String, dynamic> json) =>
      _$PlayerResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerResponseToJson(this);
}

@JsonSerializable()
class BetResponse {
  int value;
  int count;
  PlayerResponse player;

  BetResponse(this.value, this.count, this.player);

  factory BetResponse.fromJson(Map<String, dynamic> json) =>
      _$BetResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BetResponseToJson(this);
}
