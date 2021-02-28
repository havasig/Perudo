import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perudo/player.dart';

class Players extends StatelessWidget {
  final List<Player> players;

  Players({this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players'),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: players.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${players[index].username}'),
                  Checkbox(
                    value: players[index].ready,
                    onChanged: (bool value) {},
                  ),
                ],
              ),
            );
          }),
    );
  }
}
