import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bet_create_change_notifier.dart';

class BetCounter extends StatefulWidget {
  BetCounter({Key? key}) : super(key: key);

  @override
  _BetCounterState createState() => _BetCounterState();
}

class _BetCounterState extends State<BetCounter> {
  @override
  Widget build(BuildContext context) {
    var betCreate = context.watch<BetCreateChangeNotifier>();
    return Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_left),
            tooltip: 'Decrease dice pcs by 1',
            onPressed: () => {
              setState(() {
                betCreate.decrementCount();
              }),
            },
          ),
          Text('Dice ${betCreate.count}'),
          IconButton(
            icon: Icon(Icons.arrow_right),
            tooltip: 'Increase dice pcs by 1',
            onPressed: () => {
              setState(() {
                betCreate.incrementCount();
              })
            },
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_left),
            tooltip: 'Decrease dice value by 1',
            onPressed: () => {
              setState(() {
                betCreate.decrementValue();
              }),
            },
          ),
          Text('Dice ${betCreate.value}'),
          IconButton(
            icon: Icon(Icons.arrow_right),
            tooltip: 'Increase dice value by 1',
            onPressed: () => {
              setState(() {
                betCreate.incrementValue();
              })
            },
          ),
        ]),
      ],
    );
  }
}
