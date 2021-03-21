import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTurn extends StatefulWidget {
  @override
  _MyTurnState createState() => _MyTurnState();
}

class _MyTurnState extends State<MyTurn> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  /* 
  Map<String, int> myBet = {
    "count": globals.currentBet["count"]!,
    "value": globals.currentBet["value"]!
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your turn'),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(globals.myData!.username!),
            Text('Your dice: '),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: globals.myData!.diceValues!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${globals.myData!.diceValues![index]} '),
                        ],
                      ),
                    );
                  }),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_left),
                tooltip: 'Decrease my bet count by 1',
                onPressed: () {
                  setState(() {
                    if (myBet["count"]! > 1)
                      myBet["count"] = myBet["count"]! - 1;
                  });
                },
              ),
              Text('Count ${myBet["count"]}'),
              IconButton(
                icon: Icon(Icons.arrow_right),
                tooltip: 'Increase my bet count by 1',
                onPressed: () {
                  setState(() {
                    myBet["count"] = myBet["count"]! + 1;
                  });
                },
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_left),
                tooltip: 'Decrease my bet value by 1',
                onPressed: () {
                  setState(() {
                    if (myBet["value"]! > 1)
                      myBet["value"] = myBet["value"]! - 1;
                  });
                },
              ),
              Text('Value ${myBet["value"]}'),
              IconButton(
                icon: Icon(Icons.arrow_right),
                tooltip: 'Increase my bet value by 1',
                onPressed: () {
                  setState(() {
                    if (myBet["value"]! < 6)
                      myBet["value"] = myBet["value"]! + 1;
                  });
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  _isBigger(Map<String, int> currentBet, Map<String, int> myBet) {
    int? currentBetValue;
    int? myBetValue;
    if (currentBet["value"] != 1 && myBet["value"] != 1 ||
        currentBet["value"] == 1 && myBet["value"] == 1) {
      currentBetValue = currentBet["count"]! * 10 + currentBet["value"]!;
      myBetValue = myBet["count"]! * 10 + myBet["value"]!;
    } else if (currentBet["value"] != 1) {
      myBetValue = myBet["count"]! * 10 + myBet["value"]!;
      currentBetValue = currentBet["count"]! * 20 + currentBet["value"]!;
    } else if (myBet["value"] != 1) {
      myBetValue = myBet["count"]! * 20 + myBet["value"]!;
      currentBetValue = currentBet["count"]! * 10 + currentBet["value"]!;
    }
    return myBetValue! > currentBetValue!;
  } */
}
