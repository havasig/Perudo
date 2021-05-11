import 'package:flutter/material.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:provider/provider.dart';

class CurrentDiceCount extends StatelessWidget {
  const CurrentDiceCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var gameChangeNotifier = context.watch<GameChangeNotifier>();
    int diceCount = gameChangeNotifier.getDiceCount();
    return Text("Currently $diceCount dice in game");
  }
}
