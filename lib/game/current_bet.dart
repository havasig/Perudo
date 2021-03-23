import 'package:flutter/material.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:provider/provider.dart';

import '../bet.dart';

class CurrentBet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = context.watch<GameChangeNotifier>();
    Bet? currentBet = game.game.currentBet;
    if (currentBet == null)
      return Text("There is no bet, You start the game");
    else {
      return Text(
          "The current bet is ${currentBet.value}pcs ${currentBet.count} from ${currentBet.player.name}");
    }
  }
}
