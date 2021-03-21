import 'package:flutter/material.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:provider/provider.dart';

class PlayerNameText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var player = context.watch<PlayerChangeNotifier>().player;
    return Text(
      player.name.toString(),
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
