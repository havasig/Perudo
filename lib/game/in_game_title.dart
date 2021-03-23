import 'package:flutter/material.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:provider/provider.dart';

class InGameTitle extends StatelessWidget {
  const InGameTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var gameChangeNotifier = context.watch<GameChangeNotifier>();
    var player = context.watch<PlayerChangeNotifier>().player;
    return Text((() {
      if (gameChangeNotifier.game.currentPlayer.id == player.id) {
        return 'Your turn!';
      }
      return "${gameChangeNotifier.game.currentPlayer.name}'s turn";
    })());
  }
}
