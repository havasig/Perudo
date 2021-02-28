import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perudo/player.dart';
import 'package:perudo/players.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

import 'myTurn.dart';

class CreateRoom extends StatefulWidget {
  final bool isAdmin;

  CreateRoom({Key key, this.isAdmin}) : super(key: key);

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  String _username = "";
  int _dice = 5;
  bool _ready = false;
  int _myId = -1;
  TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (_myId == -1) {
      _myId = globals.players.length + 1;
      globals.players.add(Player(id: _myId, username: _username, dice: _dice));
    }
    return WillPopScope(
      onWillPop: _showLeaveAlertDialog,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
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
              new FutureBuilder<String>(
                future: _getUsername(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new Text('');
                    case ConnectionState.waiting:
                      return new Text('');
                    default:
                      if (_username == "") _username = snapshot.data;
                      return new Text(_username);
                  }
                },
              ),
              TextField(
                enabled: !_ready,
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Enter new username",
                ),
                onSubmitted: (val) {
                  setState(() {
                    if (val != "") {
                      _username = val;
                      globals.players
                          .where((player) => player.id == _myId)
                          .first
                          .username = _username;
                      _saveUsername();
                      _controller.clear();
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Username cannot be empty')));
                    }
                  });
                },
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_left),
                      tooltip: 'Decrease dice number by 1',
                      onPressed: !_ready & widget.isAdmin
                          ? () {
                              setState(() {
                                if (_dice > 1) _dice -= 1;
                              });
                            }
                          : null,
                    ),
                    Text('Dice $_dice'),
                    IconButton(
                      icon: Icon(Icons.arrow_right),
                      tooltip: 'Increase dice number by 1',
                      onPressed: !_ready & widget.isAdmin
                          ? () {
                              setState(() {
                                if (_dice < 10) _dice += 1;
                              });
                            }
                          : null,
                    ),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _ready,
                    onChanged: (value) {
                      setState(() {
                        if (_username != "") {
                          _ready = !_ready;
                          globals.players
                              .where((player) => player.id == _myId)
                              .first
                              .ready = _ready;
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Username is required'),
                          ));
                        }
                      });
                    },
                  ),
                  Text('Ready'),
                ],
              ),
              Visibility(
                visible: widget.isAdmin,
                child: RaisedButton(
                  onPressed: () {
                    if (_everyPlayerReady()) {
                      _rollDiceForEveryone();
                      globals.myData = globals.players
                          .where((player) => player.id == _myId)
                          .first;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyTurn()));
                    } else {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Not every player is ready'),
                      ));
                    }
                  },
                  child:
                      const Text('Start game', style: TextStyle(fontSize: 20)),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Players(players: globals.players)));
                },
                child: const Text('Players', style: TextStyle(fontSize: 20)),
              ),
              RaisedButton(
                onPressed: () async {
                  await _showLeaveAlertDialog().then((leave) {
                    if (leave) {
                      Navigator.of(context).pop();
                    }
                  });
                },
                child: const Text('Leave', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showLeaveAlertDialog() async {
    String text = widget.isAdmin
        ? "Are you sure You want to leave? The group will be deleted if you are the admin."
        : "Are you sure You want to leave?";
    return (await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Are you sure?"),
                content: Text(text),
                actions: [
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  FlatButton(
                    child: Text("Leave"),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              );
            })) ??
        false;
  }

  bool _everyPlayerReady() {
    for (Player player in globals.players) {
      if (!player.ready) {
        return false;
      }
    }
    return true;
  }

  _rollDiceForEveryone() {
    var rnd = new Random();
    for (Player player in globals.players) {
      player.dice = _dice;
      for (var i = 0; i < _dice; i++) {
        player.diceValues.add(rnd.nextInt(6) + 1);
      }
    }
  }

  _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _username);
  }

  Future<String> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? "";
  }
}
