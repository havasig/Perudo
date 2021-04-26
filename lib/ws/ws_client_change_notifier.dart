import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:perudo/models/json_models.dart';
import 'models.dart';
import 'dart:convert';

class WebsocketClientChangeNotifier extends ChangeNotifier {
  WebsocketClientChangeNotifier({
    this.onError,
    this.onData,
    this.hostname,
    this.port,
  });

  String? playerId;
  bool connected = false;
  String? hostname;
  int? port;
  Uint8ListCallback? onData;
  DynamicCallback? onError;
  Socket? socket;

  connect() async {
    try {
      socket = await Socket.connect(hostname, 4040);
      socket!.listen(
        onData,
        onError: onError,
        onDone: disconnect,
      );
      connected = true;
      notifyListeners();
    } on Exception catch (exception) {
      onData!(Uint8List.fromList("Error : $exception".codeUnits), socket: socket);
    }
  }

  write(String message) {
    socket!.write(message);
  }

  disconnect() {
    if (socket != null) {
      MessageDTO message = MessageDTO("leave", playerId!, playerId);
      socket!.write(json.encode(message));
      socket!.destroy();
      connected = false;
      notifyListeners();
    }
  }
}
