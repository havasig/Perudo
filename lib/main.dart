import 'package:flutter/material.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:perudo/waiting_room.dart';
import 'package:provider/provider.dart';

import 'counter/dice_counter_change_notifier.dart';
import 'game/game_change_notifier.dart';

void main() {
  runApp(Menu());
}

class Menu extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlayerChangeNotifier>(
            create: (_) => PlayerChangeNotifier()),
        ChangeNotifierProvider<DiceCounterChangeNotifier>(create: (_) => DiceCounterChangeNotifier()),
        ChangeNotifierProvider<GameChangeNotifier>(
            create: (_) => GameChangeNotifier()),
      ],
      child: MaterialApp(
        title: 'Main Menu',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainMenu(),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WaitingRoom(false)));
              },
              child: const Text('Join room'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WaitingRoom(true)));
              },
              child: const Text('Create room'),
            ),
          ],
        ),
      ),
    );
  }
}
