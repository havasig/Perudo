import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:perudo/ws/models.dart';

class WebsocketServer {
  WebsocketServer({this.onData});

  Uint8ListCallback? onData;
  ServerSocket? server;
  bool running = false;
  List<Socket> sockets = [];

  start() async {
    runZoned(() async {
      server = await ServerSocket.bind('0.0.0.0', 4040);
      this.running = true;
      server!.listen(onRequest);
    });
  }

  stop() async {
    for (Socket socket in sockets) {
      socket.close();
    }
    await this.server!.close();
    this.server = null;
    this.running = false;
  }

  send(dynamic message, {Socket? socket}) {
    if (socket != null) {
      socket.write(json.encode(message));
    } else {
      for (Socket socket in sockets) {
        socket.write(json.encode(message));
      }
    }
  }

  onRequest(Socket socket) {
    if (!sockets.contains(socket)) {
      sockets.add(socket);
    }
    socket.listen(
      (Uint8List data) {
        this.onData!(data, socket: socket);
      },
      onError: (error) {
        print(error);
        socket.close();
      },
      onDone: () {
        socket.close();
        print("client left");
        sockets.remove(socket);
      },
    );
  }
}
