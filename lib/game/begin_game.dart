import 'package:flutter/material.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:provider/provider.dart';

import '../myTurn.dart';

class BeginGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = context.watch<GameChangeNotifier>();
    return ElevatedButton(
      child: const Text('Start game'),
      onPressed: () {
        if (game.everyPlayerReady()) {
          game.rollDiceForEveryone();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyTurn()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Not every player is ready!')));
        }
      },
    );
  }
}
