import 'package:flutter/cupertino.dart';
import 'package:perudo/http/server_change_notifier.dart';
import 'package:perudo/models/json_models.dart';
import 'package:perudo/ws/ws_client_change_notifier.dart';
import 'package:perudo/ws/websocket_server.dart';

import '../models/player.dart';
import 'dart:convert';

class PlayerChangeNotifier extends ChangeNotifier {
  late Player player;
  WebsocketClientChangeNotifier? wsClient;
  WebsocketServer? wsServer;
  ServerChangeNotifier? serverChangeNotifier;

  void setName(String name) {
    player.name = name;
    if (wsClient != null) {
      MessageDTO message = MessageDTO("set-name", wsClient!.playerId!, player.name);
      wsClient!.write(json.encode(message));
    } else if (wsServer != null) {
      MessageDTO message = MessageDTO("set-name", player.id, player.name);
      wsServer!.send(message);
    }
    serverChangeNotifier?.setName(player.name);
    notifyListeners();
  }

  void setReady(bool ready) {
    player.ready = ready;
    if (wsClient != null) {
      MessageDTO message = MessageDTO("set-ready", wsClient!.playerId!, player.ready);
      wsClient!.write(json.encode(message));
    } else if (wsServer != null) {
      MessageDTO message = MessageDTO("set-ready", player.id, player.ready);
      wsServer!.send(message);
    }
    notifyListeners();
  }

  void setPlayer(Player me) {
    this.player = me;
  }

  void setWsClient(WebsocketClientChangeNotifier wsClient) {
    this.wsClient = wsClient;
  }

  void setServer(WebsocketServer wsServer) {
    this.wsServer = wsServer;
  }

  void setServerChangeNotifier(ServerChangeNotifier serverChangeNotifier) {
    this.serverChangeNotifier = serverChangeNotifier;
  }

  void setDiece(List<int> diceValues) {
    player.diceValues = diceValues;
    notifyListeners();
  }

  void removeDice() {
    if (player.diceCount! > 0) {
      player.diceValues!.removeLast();
      notifyListeners();
    }
  }
}
