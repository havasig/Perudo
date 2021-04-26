import 'package:flutter/cupertino.dart';
import 'package:perudo/ws/websocket_server.dart';
import 'package:perudo/models/json_models.dart';

class DiceCounterChangeNotifier extends ChangeNotifier {
  int count = 5;
  WebsocketServer? wsServer;

  void incrementCounter() {
    count++;
    if (wsServer != null) {
      MessageDTO message = MessageDTO("dice-count", null, count);
      wsServer!.send(message);
    }
    notifyListeners();
  }

  void decrementCounter() {
    if (count == 1) return;
    count--;
    if (wsServer != null) {
      MessageDTO message = MessageDTO("dice-count", null, count);
      wsServer!.send(message);
    }
    notifyListeners();
  }

  void setValue(int value) {
    count = value;
    notifyListeners();
  }

  void setWebsocketServer(WebsocketServer? wsServer) {
    this.wsServer = wsServer;
  }
}
