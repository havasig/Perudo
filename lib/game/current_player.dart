import 'package:flutter/material.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:provider/provider.dart';

class CurrentPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = context.watch<GameChangeNotifier>().game;
    var player = context.watch<PlayerChangeNotifier>().player;
    if (game.currentPlayer.id != player.id)
      return Text("Waiting for ${game.currentPlayer.name}");
    else {
      return Text("Please make a bet");
    }
  }
}
