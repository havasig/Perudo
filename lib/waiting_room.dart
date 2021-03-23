import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perudo/game/begin_game.dart';
import 'package:perudo/game/game_model.dart';
import 'package:perudo/game/game_change_notifier.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:perudo/player/player_name_text.dart';
import 'package:perudo/player/player_ready.dart';
import 'package:perudo/player/player_name_input.dart';
import 'package:perudo/player/players_ready_list.dart';
import 'package:provider/provider.dart';
import 'counter/dice_counter.dart';

import 'player/player.dart';

class WaitingRoom extends StatefulWidget {
  final bool isAdmin;
  WaitingRoom(this.isAdmin, {Key? key}) : super(key: key);

  @override
  _WaitingRoomState createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  @override
  void initState() {
    super.initState();

    var playerChangerNotifier = context.read<PlayerChangeNotifier>();
    var me = Player(widget.isAdmin);
    playerChangerNotifier.setPlayer(me);

    var gameChangerNotifier = context.read<GameChangeNotifier>();
    var game = Game();
    game.addPlayer(me);
    _createFakeEnemy(game);
    gameChangerNotifier.setGame(game);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var result = await showDialog(
            context: context,
            builder: (contest) {
              return areYouSure();
            });
        return result ?? false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Create Room'),
        ),
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Create Room'),
              PlayerNameInput(),
              PlayerNameText(),
              DiceCounter(),
              PlayerReady(),
              Consumer<PlayerChangeNotifier>(
                builder: (context, player, _) => Visibility(
                  visible: player.player.isAdmin,
                  child: BeginGame(),
                ),
              ),
              Consumer<GameChangeNotifier>(
                builder: (context, game, _) => ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlayersReadyList(game)));
                  },
                  child: const Text('Players'),
                ),
              ),
              ElevatedButton(
                child: const Text('Leave'),
                onPressed: () async {
                  var handlePop = await Navigator.maybePop(context);
                  if (!handlePop) {
                    SystemNavigator.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog areYouSure() {
    return AlertDialog(
      title: Text("Are you sure?"),
      content: Text(
          "Do you really want to leave? The group will be deleted if you are the admin."),
      actions: [
        TextButton(
          child: Text("No"),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: Text("Yes"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }

  void _createFakeEnemy(Game game) {
    Player tmp1 = Player(false);
    Player tmp2 = Player(false);
    Player tmp3 = Player(false);
    Player tmp4 = Player(false);
    tmp1.name = "Tmp1";
    tmp2.name = "Tmp2";
    tmp3.name = "Tmp3";
    tmp4.name = "Tmp4";
    tmp1.ready = true;
    tmp2.ready = true;
    tmp3.ready = true;
    tmp4.ready = true;
    game.addPlayer(tmp1);
    game.addPlayer(tmp2);
    game.addPlayer(tmp3);
    game.addPlayer(tmp4);
  }
}
