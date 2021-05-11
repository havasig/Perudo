import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perudo/counter/bet_counter.dart';
import 'package:perudo/counter/bet_create_change_notifier.dart';
import 'package:perudo/counter/bet_widget.dart';
import 'package:perudo/game/current_dice_count.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:perudo/game/make_bet_server.dart';
import 'package:perudo/models/bet.dart';
import 'package:perudo/models/game.dart';
import 'package:perudo/models/json_models.dart';
import 'package:perudo/models/player.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:perudo/ws/websocket_server.dart';
import 'package:provider/provider.dart';

import 'current_bet.dart';
import 'current_player.dart';
import 'in_game_title.dart';
import 'my_dice.dart';

class InGame extends StatefulWidget {
  @override
  _InGameState createState() => _InGameState();
}

class _InGameState extends State<InGame> {
  bool _startNewGame = false;

  @override
  Widget build(BuildContext context) {
    WebsocketServer wsServer = InheritedWsServerProvider.of(context)!.websocketServer;
    var me = context.watch<PlayerChangeNotifier>().player;
    Bet? currentBet = context.read<GameChangeNotifier>().game.currentBet;

    return ChangeNotifierProvider(
      create: (_) => BetCreateChangeNotifier(currentBet?.count, currentBet?.value),
      child: Scaffold(
        appBar: AppBar(
          title: InGameTitle(),
        ),
        body: Column(children: <Widget>[
          MyDice(),
          CurrentDiceCount(),
          CurrentBet(),
          CurrentPlayer(),
          Consumer<GameChangeNotifier>(
            builder: (context, game, _) =>
                game.game.currentPlayer.id == me.id && !game.game.startNewGame ? MakeBetServer(wsServer) : Container(),
          ),
          Consumer<GameChangeNotifier>(
            builder: (context, game, _) => game.game.startNewGame
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        game.game.startNewGame = !game.game.startNewGame;
                        game.startNewRound();
                        MessageDTO startNewRound = MessageDTO("start-round", me.id, game.game.toDTO());
                        wsServer.send(startNewRound);
                      });
                    },
                    child: const Text('Start next round'),
                  )
                : Container(),
          ),
        ]),
      ),
    );
  }
}
