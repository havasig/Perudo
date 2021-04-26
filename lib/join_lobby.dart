import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perudo/counter/dice_counter_change_notifier.dart';
import 'package:perudo/game/begin_game.dart';
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
    client = WebsocketClientChangeNotifier(
        hostname: widget.ip.address, port: 4040, onData: this.onData, onError: this.onError);
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
    return ChangeNotifierProvider<WebsocketClientChangeNotifier>.value(
      value: client,
      child: WillPopScope(
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
                    Consumer<PlayerChangeNotifier>(
                      builder: (context, player, _) => Visibility(
                        visible: player.player.isAdmin,
                        child: BeginGame(),
                      ),
                    ),
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
                        client.write("hello, i am client");
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
      ),
    );
  }
}
