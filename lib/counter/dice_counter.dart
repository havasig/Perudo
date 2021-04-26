import 'package:flutter/material.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:perudo/ws/websocket_server.dart';
import 'package:provider/provider.dart';

import '../app_config.dart';
import '../models/player.dart';
import 'dice_counter_change_notifier.dart';

class DiceCounter extends StatefulWidget {
  final WebsocketServer? wsServer;
  DiceCounter({Key? key, this.wsServer}) : super(key: key);

  @override
  _DiceCounterState createState() => _DiceCounterState();
}

class _DiceCounterState extends State<DiceCounter> {
  late AppConfig config;

  @override
  void initState() {
    super.initState();
    getConfig().then((value) => config = value);
  }

  @override
  Widget build(BuildContext context) {
    DiceCounterChangeNotifier counter = context.watch<DiceCounterChangeNotifier>();
    counter.setWebsocketServer(widget.wsServer);
    Player player = context.watch<PlayerChangeNotifier>().player;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
        icon: Icon(Icons.arrow_left),
        tooltip: 'Decrease dice number by 1',
        onPressed: !player.ready & player.isAdmin
            ? () {
                setState(() {
                  counter.decrementCounter();
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
                  if (counter.count < config.maxDiceNumber) counter.incrementCounter();
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
