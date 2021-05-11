import 'package:flutter/material.dart';
import 'package:perudo/counter/dice_counter_change_notifier.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:perudo/models/game.dart';
import 'package:perudo/models/json_models.dart';
import 'package:perudo/ws/websocket_server.dart';
import 'package:provider/provider.dart';

import 'in_game.dart';

class BeginGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = context.watch<GameChangeNotifier>();
    var counter = context.watch<DiceCounterChangeNotifier>();
    WebsocketServer wsServer = InheritedWsServerProvider.of(context)!.websocketServer;
    return ElevatedButton(
      child: const Text('Start game'),
      onPressed: () {
        if (game.everyPlayerReady()) {
          game.start(counter.count);
          this.sendDiceValues(wsServer, game.game);
          this.notifyPlayers(wsServer);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InheritedWsServerProvider(
                        child: InGame(),
                        websocketServer: wsServer,
                      )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not every player is ready!')));
        }
      },
    );
  }

  void notifyPlayers(WebsocketServer wsServer) {
    MessageDTO message = MessageDTO("start-game", null, "");
    wsServer.send(message);
  }

  void sendDiceValues(WebsocketServer wsServer, Game game) {
    List<PlayerDTO> players = game.players.map((player) => player.toDTO()).toList();
    MessageDTO message = MessageDTO("dice-values", null, players);
    wsServer.send(message);
  }
}
