import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:provider/provider.dart';

class PlayerReady extends StatefulWidget {
  PlayerReady({Key? key}) : super(key: key);

  @override
  _PlayerReadyState createState() => _PlayerReadyState();
}

class _PlayerReadyState extends State<PlayerReady> {
  bool ready = false;
  @override
  Widget build(BuildContext context) {
    var player = context.read<PlayerChangeNotifier>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: ready,
          onChanged: (value) {
            setState(() {
              if (player.player.name == "") {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Name cannot be empty!')));
              } else {
                ready = !ready;
                player.setReady(ready);
              }
            });
          },
        ),
        Text('Ready'),
      ],
    );
  }
}
