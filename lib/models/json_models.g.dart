// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameResponse _$GameResponseFromJson(Map<String, dynamic> json) {
  return GameResponse(
    json['id'] as int,
    json['startDiceNumber'] as int,
    (json['players'] as List<dynamic>)
        .map((e) => PlayerResponse.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['turn'] as bool,
    json['currentBet'] == null
        ? null
        : BetResponse.fromJson(json['currentBet'] as Map<String, dynamic>),
    PlayerResponse.fromJson(json['currentPlayer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GameResponseToJson(GameResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDiceNumber': instance.startDiceNumber,
      'players': instance.players,
      'turn': instance.turn,
      'currentBet': instance.currentBet,
      'currentPlayer': instance.currentPlayer,
    };

PlayerResponse _$PlayerResponseFromJson(Map<String, dynamic> json) {
  return PlayerResponse(
    json['id'] as int,
    json['ready'] as bool,
    (json['diceValues'] as List<dynamic>).map((e) => e as int).toList(),
    json['name'] as String,
    json['isAdmin'] as bool,
  );
}

Map<String, dynamic> _$PlayerResponseToJson(PlayerResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ready': instance.ready,
      'diceValues': instance.diceValues,
      'name': instance.name,
      'isAdmin': instance.isAdmin,
    };

BetResponse _$BetResponseFromJson(Map<String, dynamic> json) {
  return BetResponse(
    json['value'] as int,
    json['count'] as int,
    PlayerResponse.fromJson(json['player'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BetResponseToJson(BetResponse instance) =>
    <String, dynamic>{
      'value': instance.value,
      'count': instance.count,
      'player': instance.player,
    };
