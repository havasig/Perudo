import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perudo/alert_dialogs.dart';
import 'package:perudo/counter/bet_create_change_notifier.dart';
import 'package:perudo/game/current_dice_count.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:perudo/game/make_bet_client.dart';
import 'package:perudo/models/bet.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:perudo/ws/ws_client_change_notifier.dart';
import 'package:provider/provider.dart';

import 'current_bet.dart';
import 'current_player.dart';
import 'in_game_title.dart';
import 'my_dice.dart';

class InGameClient extends StatefulWidget {
  @override
  _InGameClientState createState() => _InGameClientState();
}

class _InGameClientState extends State<InGameClient> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var me = context.watch<PlayerChangeNotifier>().player;
    Bet? currentBet = context.read<GameChangeNotifier>().game.currentBet;
    WebsocketClientChangeNotifier wsClient = context.watch<WebsocketClientChangeNotifier>();

    return ChangeNotifierProvider(
      create: (_) => BetCreateChangeNotifier(currentBet?.count, currentBet?.value),
      child: Scaffold(
        appBar: AppBar(
          title: InGameTitle(),
        ),
        body: Column(
          children: (() {
            if (!wsClient.connected) {
              return <Widget>[AlertDialogs.connectionError(context)];
            }
            return <Widget>[
              MyDice(),
              CurrentDiceCount(),
              CurrentBet(),
              CurrentPlayer(),
              Consumer<GameChangeNotifier>(
                  builder: (context, game, _) => game.game.currentPlayer.id == me.id && game.game.startNewGame ? MakeBetClient() : Container()),
            ];
          }()),
        ),
      ),
    );
  }
}
