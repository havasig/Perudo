import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perudo/join_lobby.dart';
import 'package:provider/provider.dart';

import 'server_change_notifier.dart';

class AvailableServers extends StatefulWidget {
  AvailableServers({Key? key}) : super(key: key);

  @override
  _AvailableServersState createState() => _AvailableServersState();
}

class _AvailableServersState extends State<AvailableServers> {
  @override
  Widget build(BuildContext context) {
    var server = context.watch<ServerChangeNotifier>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Available Servers'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          ElevatedButton(
            onPressed: () {
              context.read<ServerChangeNotifier>().refreshServers();
            },
            child: const Text('Refresh servers'),
          ),
          Text('${server.availableServers.length}'),
          server.availableServers.length > 0
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: server.availableServers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => JoinLobby(server.availableServers[index].first)));
                            },
                            child: Text('Join to: ${server.availableServers[index].second}'),
                          ),
                        ],
                      ),
                    );
                  })
              : Text('No items'),
        ]),
      ),
    );
  }
}
