import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perudo/counter/dice_counter_change_notifier.dart';
import 'package:perudo/game/begin_game.dart';
import 'package:perudo/http/server_change_notifier.dart';
import 'package:perudo/models/bet.dart';
import 'package:perudo/models/game.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:perudo/models/json_models.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:perudo/player/player_name_text.dart';
import 'package:perudo/player/player_ready.dart';
import 'package:perudo/player/player_name_input.dart';
import 'package:perudo/player/players_ready_list.dart';
import 'package:perudo/ws/websocket_server.dart';
import 'package:provider/provider.dart';
import 'alert_dialogs.dart';
import 'counter/dice_counter.dart';
import 'dart:convert';

import 'main.dart';
import 'models/player.dart';

class CreateLobby extends StatefulWidget {
  CreateLobby({Key? key}) : super(key: key);

  @override
  _CreateLobbyState createState() => _CreateLobbyState();
}

class _CreateLobbyState extends State<CreateLobby> {
  late WebsocketServer serverWebsocket;
  late ServerChangeNotifier serverChangeNotifier;

  onData(Uint8List data, {Socket? socket}) {
    decode(data);
  }

  void decode(Uint8List data) {
    var message = json.decode(String.fromCharCodes(data));
    switch (message["messageType"]) {
      case "join":
        {
          var gameChangeNotifier = context.read<GameChangeNotifier>();
          PlayerDTO newPlayerDTO = PlayerDTO(
              message["object"]["id"],
              message["object"]["ready"],
              message["object"]["diceValues"].cast<int>(),
              message["object"]["name"],
              message["object"]["diceCount"],
              message["object"]["isAdmin"]);
          gameChangeNotifier.addPlayer(newPlayerDTO.toPlayer());
          MessageDTO messageDto = MessageDTO("game", null, gameChangeNotifier.game.toDTO());
          serverWebsocket.send(messageDto);
          sleep(const Duration(seconds: 1));
          serverWebsocket.send(MessageDTO("dice-count", null, context.read<DiceCounterChangeNotifier>().count));
        }
        break;

      case "leave":
        {
          var gameChangeNotifier = context.read<GameChangeNotifier>();
          gameChangeNotifier.removePlayer(message["object"]);
        }
        break;

      case "set-name":
        {
          var gameChangeNotifier = context.read<GameChangeNotifier>();
          gameChangeNotifier.setPlayerName(message["userId"], message["object"]);
          MessageDTO messageDto = MessageDTO("set-name", message["userId"], message["object"]);
          serverWebsocket.send(messageDto);
        }
        break;

      case "set-ready":
        {
          var gameChangeNotifier = context.read<GameChangeNotifier>();
          gameChangeNotifier.setPlayerReady(message["userId"], message["object"]);
          MessageDTO messageDto = MessageDTO("set-ready", message["userId"], message["object"]);
          serverWebsocket.send(messageDto);
        }
        break;

      case "make-bet":
        {
          var gameChangeNotifier = context.read<GameChangeNotifier>();
          var player = gameChangeNotifier.getPlayer(message["userId"]);
          var betCreate = BetDTO(message["object"]["value"], message["object"]["count"], player.toDTO());
          Bet newBet = betCreate.toBet();
          gameChangeNotifier.makeBet(newBet);
          MessageDTO betDto = MessageDTO("make-bet", player.id, newBet.toDTO());
          serverWebsocket.send(betDto);
          gameChangeNotifier.nextPlayer();
        }
        break;

      case "lie":
        {
          var game = context.read<GameChangeNotifier>();
          var player = game.getPlayer(message["userId"]);
          var looser = game.lie(player);
          var looserId = looser.id;
          var me = context.read<PlayerChangeNotifier>().player;
          game.game.startNewGame = true;
          MessageDTO lieMessage = MessageDTO("lie", message["userId"], looserId);
          serverWebsocket.send(lieMessage);
          if (looserId == me.id) {
            context.read<PlayerChangeNotifier>().removeDice();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You lost a dice')));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Player ' + looser.name + ' lost a dice')));
          }
          if (game.game.players.length == 1) {
            if (game.game.players[0].id == player.id) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You won the game! Well done!')));
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(game.game.players[0].name + ' won the game!')));
            }
            serverWebsocket.stop();
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

      default:
        {
          print("Invalid choice");
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    serverWebsocket = WebsocketServer(onData: this.onData);
    context.read<PlayerChangeNotifier>().setServer(serverWebsocket);

    var me = Player(true);
    context.read<PlayerChangeNotifier>().setPlayer(me);

    startServer();

    Game game = Game(me, []);
    game.addPlayer(me);
    //_createFakeEnemy(game);

    context.read<GameChangeNotifier>().setGame(game);

    serverChangeNotifier = context.read<ServerChangeNotifier>();
    serverChangeNotifier.startServer();
    context.read<PlayerChangeNotifier>().setServerChangeNotifier(serverChangeNotifier);
  }

  void startServer() async {
    if (serverWebsocket.running) {
      await serverWebsocket.stop();
    } else {
      await serverWebsocket.start();
    }
  }

  @override
  void dispose() {
    serverChangeNotifier.closeServer();
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
        if (result) {
          serverWebsocket.stop();
        }
        return result ?? false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Create lobby'),
        ),
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Create lobby'),
              PlayerNameInput(),
              PlayerNameText(),
              DiceCounter(wsServer: serverWebsocket),
              PlayerReady(),
              InheritedWsServerProvider(
                child: BeginGame(),
                websocketServer: serverWebsocket,
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
                  var handlePop = await Navigator.maybePop(context);
                  if (!handlePop) {
                    SystemNavigator.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createFakeEnemy(Game game) {
    Player tmp1 = Player(false);
    Player tmp2 = Player(false);
    Player tmp3 = Player(false);
    Player tmp4 = Player(false);
    tmp1.name = "Tmp1";
    tmp2.name = "Tmp2";
    tmp3.name = "Tmp3";
    tmp4.name = "Tmp4";
    tmp1.ready = true;
    tmp2.ready = true;
    tmp3.ready = true;
    tmp4.ready = true;
    game.addPlayer(tmp1);
    game.addPlayer(tmp2);
    game.addPlayer(tmp3);
    game.addPlayer(tmp4);
  }
}
