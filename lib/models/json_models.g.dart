// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameDTO _$GameDTOFromJson(Map<String, dynamic> json) {
  return GameDTO(
    json['id'] as int,
    json['startDiceNumber'] as int,
    (json['players'] as List<dynamic>)
        .map((e) => PlayerDTO.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['turn'] as bool,
    json['currentBet'] == null
        ? null
        : BetDTO.fromJson(json['currentBet'] as Map<String, dynamic>),
    PlayerDTO.fromJson(json['currentPlayer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GameDTOToJson(GameDTO instance) => <String, dynamic>{
      'id': instance.id,
      'startDiceNumber': instance.startDiceNumber,
      'players': instance.players,
      'turn': instance.turn,
      'currentBet': instance.currentBet,
      'currentPlayer': instance.currentPlayer,
    };

PlayerDTO _$PlayerDTOFromJson(Map<String, dynamic> json) {
  return PlayerDTO(
    json['id'] as String,
    json['ready'] as bool,
    (json['diceValues'] as List<dynamic>).map((e) => e as int).toList(),
    json['name'] as String,
    json['isAdmin'] as bool,
  );
}

Map<String, dynamic> _$PlayerDTOToJson(PlayerDTO instance) => <String, dynamic>{
      'id': instance.id,
      'ready': instance.ready,
      'diceValues': instance.diceValues,
      'name': instance.name,
      'isAdmin': instance.isAdmin,
    };

BetDTO _$BetDTOFromJson(Map<String, dynamic> json) {
  return BetDTO(
    json['value'] as int,
    json['count'] as int,
    PlayerDTO.fromJson(json['player'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BetDTOToJson(BetDTO instance) => <String, dynamic>{
      'value': instance.value,
      'count': instance.count,
      'player': instance.player,
    };

MessageDTO _$MessageDTOFromJson(Map<String, dynamic> json) {
  return MessageDTO(
    json['messageType'] as String,
    json['userId'] as String?,
    json['object'],
  );
}

Map<String, dynamic> _$MessageDTOToJson(MessageDTO instance) =>
    <String, dynamic>{
      'messageType': instance.messageType,
      'userId': instance.userId,
      'object': instance.object,
    };
