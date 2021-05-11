import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perudo/counter/dice_counter_change_notifier.dart';
import 'package:perudo/game/in_game_client.dart';
import 'package:perudo/main.dart';
import 'package:perudo/models/game.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:perudo/models/json_models.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:perudo/player/player_name_text.dart';
import 'package:perudo/player/player_ready.dart';
import 'package:perudo/player/player_name_input.dart';
import 'package:perudo/player/players_ready_list.dart';
import 'package:perudo/ws/ws_client_change_notifier.dart';
import 'package:provider/provider.dart';
import 'alert_dialogs.dart';
import 'counter/dice_counter.dart';
import 'dart:io';
import 'dart:convert';

import 'models/bet.dart';
import 'models/player.dart';

class JoinLobby extends StatefulWidget {
  late final InternetAddress ip;
  JoinLobby(this.ip, {Key? key}) : super(key: key);

  @override
  _JoinLobbyState createState() => _JoinLobbyState();
}

class _JoinLobbyState extends State<JoinLobby> {
  late WebsocketClientChangeNotifier client;
  late Player me;

  @override
  void initState() {
    client = context.read<WebsocketClientChangeNotifier>();
    client.init(this.onError, this.onData, widget.ip.address, 4040);

    connectToWsServer();
    context.read<PlayerChangeNotifier>().setWsClient(client);

    me = Player(false);
    context.read<PlayerChangeNotifier>().setPlayer(me);
    client.playerId = me.id;

    super.initState();
  }

  void connectToWsServer() async {
    await client.connect();
    joinToGame();
  }

  void joinToGame() {
    MessageDTO message = MessageDTO("join", me.id!, me.toDTO());
    client.write(json.encode(message));
  }

  onData(Uint8List data, {Socket? socket}) {
    print("join lobby on data: " + String.fromCharCodes(data));
    decode(data);
  }

  void decode(Uint8List data) {
    var message = json.decode(String.fromCharCodes(data));
    switch (message["messageType"]) {
      case "game":
        {
          GameDTO gameDto = GameDTO.fromJson(message["object"]);
          Game game = gameDto.toGame();
          game.removePlayer(client.playerId!);
          game.addPlayer(context.read<PlayerChangeNotifier>().player);
          context.read<DiceCounterChangeNotifier>().setValue(message["object"]["startDiceNumber"]);
          context.read<GameChangeNotifier>().setGame(game);
        }
        break;

      case "set-name":
        {
          if (message["userId"] != client.playerId) {
            context.read<GameChangeNotifier>().setPlayerName(message["userId"], message["object"]);
          }
        }
        break;

      case "set-ready":
        {
          if (message["userId"] != client.playerId) {
            context.read<GameChangeNotifier>().setPlayerReady(message["userId"], message["object"]);
          }
        }
        break;

      case "dice-count":
        {
          context.read<DiceCounterChangeNotifier>().setValue(message["object"]);
        }
        break;

      case "start-game":
        {
          context.read<GameChangeNotifier>().game.startNewGame = true;
          Navigator.push(context, MaterialPageRoute(builder: (context) => InGameClient()));
        }
        break;

      case "dice-values":
        {
          List<dynamic> players = message["object"];
          var game = context.read<GameChangeNotifier>().game;
          players.forEach((player) {
            List<dynamic> asd = player["diceValues"];
            List<int> newDiceValues = asd.map((e) => e as int).toList();
            game.players.where((gamePlayer) => gamePlayer.id == player["id"]).first.diceValues = newDiceValues;
            game.players.where((gamePlayer) => gamePlayer.id == player["id"]).first.diceCount = newDiceValues.length;
          });
          List<dynamic> diceValues = players.where((player) => player["id"] == me.id).first["diceValues"];
          List<int> intDiceValues = diceValues.map((e) => e as int).toList();
          context.read<PlayerChangeNotifier>().setDiece(intDiceValues);
        }
        break;

      case "start-round":
        {
          GameChangeNotifier gameNotifier = context.read<GameChangeNotifier>();
          gameNotifier.game.startNewGame = true;
          GameDTO gameDto = GameDTO.fromJson(message["object"]);
          Game game = gameDto.toGame();
          gameNotifier.game.currentBet = game.currentBet;
          gameNotifier.game.currentPlayer = game.currentPlayer;
          String? remove;
          game.players.forEach((gamePlayer) {
            var exists = false;
            gameNotifier.game.players.forEach((element) {
              if (element.id == gamePlayer.id) {
                exists = true;
              }
            });
            if (!exists) {
              remove = gamePlayer.id;
            }
          });
          if (remove != null) {
            gameNotifier.game.removePlayer(remove!);
          }
          List<int> diceValues = game.players.where((element) => element.id == me.id).first.diceValues!;
          context.read<PlayerChangeNotifier>().setDiece(diceValues);
        }
        break;

      case "make-bet":
        {
          GameChangeNotifier game = context.read<GameChangeNotifier>();
          BetDTO betDto = BetDTO.fromJson(message["object"]);
          Bet bet = betDto.toBet();
          game.setCurrentBet(bet);
          game.nextPlayer();
        }
        break;

      case "lie":
        {
          var looserId = message["object"];
          GameChangeNotifier game = context.read<GameChangeNotifier>();
          var me = context.read<PlayerChangeNotifier>();
          if (looserId == me.player.id) {
            me.removeDice();
            context.read<PlayerChangeNotifier>().player.looseDice();
            if (me.player.diceCount == 0) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You lost the game')));
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MainMenu(),
                ),
                (route) => false,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You lost a dice')));
            }
          } else {
            var looser = game.game.players.where((element) => element.id == looserId).first;
            game.setDiceNumber(looser, looser.diceCount! - 1);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Player ' + looser.name + ' lost a dice')));
          }
          if (game.game.players.length == 1) {
            if (game.game.players[0].id == me.player.id) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You won the game! Well done!')));
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(game.game.players[0].name + ' won the game!')));
            }
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MainMenu(),
              ),
              (route) => false,
            );
          }
        }
        break;
    }
  }

  onError(dynamic error) {
    print(error);
  }

  @override
  dispose() {
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var result = await showDialog(
            context: context,
            builder: (contest) {
              return AlertDialogs.areYouSure(context);
            });
        return result ?? false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Lobby'),
        ),
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: Consumer<WebsocketClientChangeNotifier>(
            builder: (context, wsClient, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: (() {
                if (!wsClient.connected) {
                  return <Widget>[AlertDialogs.connectionError(context)];
                }
                return <Widget>[
                  Text('Lobby'),
                  PlayerNameInput(),
                  PlayerNameText(),
                  DiceCounter(),
                  PlayerReady(),
                  Consumer<GameChangeNotifier>(
                    builder: (context, game, _) => ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayersReadyList(game)));
                      },
                      child: const Text('Players'),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('Leave'),
                    onPressed: () async {
                      var handlePop = await Navigator.maybePop(context);
                      if (!handlePop) {
                        SystemNavigator.pop();
                      }
                    },
                  ),
                ];
              }()),
            ),
          ),
        ),
      ),
    );
  }
}
