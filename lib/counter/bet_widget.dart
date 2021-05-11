import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perudo/counter/bet_counter.dart';

class BetWidget extends StatefulWidget {
  @override
  _BetWidgetState createState() => _BetWidgetState();
}

class _BetWidgetState extends State<BetWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      BetCounter(),
      ElevatedButton(
        onPressed: () {
          print("make bet");
        },
        child: const Text('Make bet'),
      ),
    ]);
  }
}
