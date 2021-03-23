import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perudo/counter/bet_counter.dart';
import 'package:perudo/counter/bet_create_change_notifier.dart';
import 'package:perudo/counter/bet_widget.dart';
import 'package:perudo/game/current_dice_count.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:provider/provider.dart';

import 'current_bet.dart';
import 'current_player.dart';
import 'in_game_title.dart';
import 'my_dice.dart';

class InGame extends StatefulWidget {
  @override
  _InGameState createState() => _InGameState();
}

class _InGameState extends State<InGame> {
  @override
  Widget build(BuildContext context) {
    var me = context.watch<PlayerChangeNotifier>().player;
    return ChangeNotifierProvider(
      create: (_) => BetCreateChangeNotifier(),
      child: Scaffold(
        appBar: AppBar(
          title: InGameTitle(),
        ),
        body: Column(children: <Widget>[
          MyDice(),
          CurrentDiceCount(),
          CurrentBet(),
          CurrentPlayer(),
          Consumer<GameChangeNotifier>(
              builder: (context, game, _) => game.game.currentPlayer.id == me.id
                  ? BetWidget()
                  : Container()),
        ]),
      ),
    );
  }

/*             Text(globals.myData!.username!),
            Text('Your dice: '),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: globals.myData!.diceValues!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${globals.myData!.diceValues![index]} '),
                        ],
                      ),
                    );
                  }),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_left),
                tooltip: 'Decrease my bet count by 1',
                onPressed: () {
                  setState(() {
                    if (myBet["count"]! > 1)
                      myBet["count"] = myBet["count"]! - 1;
                  });
                },
              ),
              Text('Count ${myBet["count"]}'),
              IconButton(
                icon: Icon(Icons.arrow_right),
                tooltip: 'Increase my bet count by 1',
                onPressed: () {
                  setState(() {
                    myBet["count"] = myBet["count"]! + 1;
                  });
                },
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_left),
                tooltip: 'Decrease my bet value by 1',
                onPressed: () {
                  setState(() {
                    if (myBet["value"]! > 1)
                      myBet["value"] = myBet["value"]! - 1;
                  });
                },
              ),
              Text('Value ${myBet["value"]}'),
              IconButton(
                icon: Icon(Icons.arrow_right),
                tooltip: 'Increase my bet value by 1',
                onPressed: () {
                  setState(() {
                    if (myBet["value"]! < 6)
                      myBet["value"] = myBet["value"]! + 1;
                  });
                },
              ),
            ]), */

  _isBigger(Map<String, int> currentBet, Map<String, int> myBet) {
    int? currentBetValue;
    int? myBetValue;
    if (currentBet["value"] != 1 && myBet["value"] != 1 ||
        currentBet["value"] == 1 && myBet["value"] == 1) {
      currentBetValue = currentBet["count"]! * 10 + currentBet["value"]!;
      myBetValue = myBet["count"]! * 10 + myBet["value"]!;
    } else if (currentBet["value"] != 1) {
      myBetValue = myBet["count"]! * 10 + myBet["value"]!;
      currentBetValue = currentBet["count"]! * 20 + currentBet["value"]!;
    } else if (myBet["value"] != 1) {
      myBetValue = myBet["count"]! * 20 + myBet["value"]!;
      currentBetValue = currentBet["count"]! * 10 + currentBet["value"]!;
    }
    return myBetValue! > currentBetValue!;
  }
}
