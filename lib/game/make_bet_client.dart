import 'package:flutter/material.dart';
import 'package:perudo/counter/bet_counter.dart';
import 'package:perudo/counter/bet_create_change_notifier.dart';
import 'package:perudo/models/bet.dart';
import 'package:perudo/models/json_models.dart';
import 'package:perudo/models/player.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:perudo/ws/ws_client_change_notifier.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'game_change_notifier.dart';

class MakeBetClient extends StatefulWidget {
  MakeBetClient({Key? key}) : super(key: key);

  @override
  _MakeBetClientState createState() => _MakeBetClientState();
}

class _MakeBetClientState extends State<MakeBetClient> {
  @override
  Widget build(BuildContext context) {
    WebsocketClientChangeNotifier wsClient = context.watch<WebsocketClientChangeNotifier>();
    BetCreateChangeNotifier betCreate = context.watch<BetCreateChangeNotifier>();
    GameChangeNotifier game = context.watch<GameChangeNotifier>();
    var _isButtonDisabled = game.game.currentBet == null;
    Player me = context.watch<PlayerChangeNotifier>().player;
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        BetCounter(),
        ElevatedButton(
          onPressed: () {
            Bet newBet = Bet(betCreate.value, betCreate.count, me);
            bool success = game.makeBet(newBet);
            if (success) {
              MessageDTO betDto = MessageDTO("make-bet", me.id, newBet.toDTO());
              wsClient.write(json.encode(betDto));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bet is too small')));
            }
          },
          child: const Text('Make bet'),
        ),
        ElevatedButton(
          onPressed: _isButtonDisabled
              ? null
              : () {
                  game.game.startNewGame = false;
                  wsClient.write(json.encode(MessageDTO("lie", me.id, null)));
                },
          child: const Text(r"It's a lie"),
        ),
      ]),
    );
  }
}
