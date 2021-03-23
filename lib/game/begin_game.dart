import 'package:flutter/material.dart';
import 'package:perudo/counter/dice_counter_change_notifier.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:provider/provider.dart';

import 'in_game.dart';

class BeginGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = context.watch<GameChangeNotifier>();
    var counter = context.watch<DiceCounterChangeNotifier>();
    return ElevatedButton(
      child: const Text('Start game'),
      onPressed: () {
        if (game.everyPlayerReady()) {
          game.start(counter.count);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => InGame()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Not every player is ready!')));
        }
      },
    );
  }
}
