import 'package:flutter/material.dart';
import 'package:perudo/counter/bet_counter.dart';
import 'package:perudo/counter/bet_create_change_notifier.dart';
import 'package:perudo/models/bet.dart';
import 'package:perudo/models/json_models.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:perudo/ws/websocket_server.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'game_change_notifier.dart';

class MakeBetServer extends StatefulWidget {
  late final WebsocketServer wsServer;
  MakeBetServer(this.wsServer, {Key? key}) : super(key: key);

  @override
  _MakeBetServerState createState() => _MakeBetServerState();
}

class _MakeBetServerState extends State<MakeBetServer> {
  @override
  Widget build(BuildContext context) {
    BetCreateChangeNotifier betCreate = context.watch<BetCreateChangeNotifier>();
    GameChangeNotifier game = context.watch<GameChangeNotifier>();
    var _isButtonDisabled = game.game.currentBet == null;
    var me = context.watch<PlayerChangeNotifier>();
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        BetCounter(),
        ElevatedButton(
          onPressed: () {
            Bet newBet = Bet(betCreate.value, betCreate.count, me.player);
            bool success = game.makeBet(newBet);
            if (success) {
              MessageDTO betDto = MessageDTO("make-bet", me.player.id, newBet.toDTO());
              widget.wsServer.send(betDto);
              game.nextPlayer();
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
                  var looser = game.lie(me.player);
                  var looserId = looser.id;
                  game.game.startNewGame = true;
                  MessageDTO lieMessage = MessageDTO("lie", me.player.id, looserId);
                  widget.wsServer.send(lieMessage);
                  if (looserId == me.player.id) {
                    me.removeDice();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You lost a dice')));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Player ' + looser.name + ' lost a dice')));
                  }
                  if (game.game.players.length == 1) {
                    if (game.game.players[0].id == me.player.id) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('You won the game! Well done!')));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(game.game.players[0].name + ' won the game!')));
                    }
                    widget.wsServer.stop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MainMenu(),
                      ),
                      (route) => false,
                    );
                  }
                },
          child: const Text(r"It's a lie"),
        ),
      ]),
    );
  }
}
