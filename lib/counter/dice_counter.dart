import 'package:flutter/material.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:provider/provider.dart';

import '../app_config.dart';
import '../player/player.dart';
import 'counter.dart';

class DiceCounter extends StatefulWidget {
  DiceCounter({Key? key}) : super(key: key);

  @override
  _DiceCounterState createState() => _DiceCounterState();
}

class _DiceCounterState extends State<DiceCounter> {
  late Counter counter;
  late Player player;
  late AppConfig config;
  @override
  void initState() {
    super.initState();
    getConfig().then((value) => config = value);
  }

  @override
  Widget build(BuildContext context) {
    counter = context.watch<Counter>();
    player = context.watch<PlayerChangeNotifier>().player;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
        icon: Icon(Icons.arrow_left),
        tooltip: 'Decrease dice number by 1',
        onPressed: !player.ready & player.isAdmin
            ? () {
                setState(() {
                  if (counter.count > 1) counter.decrementCounter();
                });
              }
            : null,
      ),
      Text('Dice ${counter.count}'),
      IconButton(
        icon: Icon(Icons.arrow_right),
        tooltip: 'Increase dice number by 1',
        onPressed: !player.ready & player.isAdmin
            ? () {
                setState(() {
                  if (counter.count < config.maxDiceNumber)
                    counter.incrementCounter();
                });
              }
            : null,
      ),
    ]);
  }

  Future<AppConfig> getConfig() async {
    return await AppConfig.forEnvironment();
  }
}
