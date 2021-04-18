import 'package:flutter/material.dart';
import 'package:perudo/player/player_change_notifier.dart';
import 'package:provider/provider.dart';

class PlayerNameInput extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var player = context.watch<PlayerChangeNotifier>();
    return TextField(
      enabled: !player.player.ready,
      controller: _controller,
      decoration: InputDecoration(
        labelText: "Enter new name",
      ),
      onSubmitted: (newName) {
        if (newName != "") {
          player.setName(newName);
          _controller.clear();
        } else if (player.player.name == "") {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Name cannot be empty!')));
        }
      },
    );
  }
}
