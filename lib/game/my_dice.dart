import 'package:flutter/material.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:provider/provider.dart';

class MyDice extends StatelessWidget {
  const MyDice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var player = context.watch<PlayerChangeNotifier>().player;
    return GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        children: List.generate(player.diceValues!.length, (index) {
          return Center(
              child: Image(
                  image: AssetImage('assets/images/dice${player.diceValues![index]}.png'), height: 50, width: 50));
        }));
  }
}
