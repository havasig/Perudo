import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perudo/game/game_change_notifier.dart';

class PlayersReadyList extends StatelessWidget {
  final GameChangeNotifier gameChangeNotifier;
  PlayersReadyList(this.gameChangeNotifier);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players'),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: gameChangeNotifier.game.players.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text((() {
                    if (gameChangeNotifier.game.players[index].name == "") {
                      return "No name given";
                    }
                    return '${gameChangeNotifier.game.players[index].name}';
                  })()),
                  Checkbox(
                    value: gameChangeNotifier.game.players[index].ready,
                    onChanged: (bool? value) {},
                  ),
                ],
              ),
            );
          }),
    );
  }
}
