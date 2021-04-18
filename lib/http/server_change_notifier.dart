import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert' show utf8;

import '../pair.dart';

class ServerChangeNotifier extends ChangeNotifier {
  RawDatagramSocket? datagramSocket;
  List<Pair> availableServers = [];

  startServer() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 4041).then((ds) {
      datagramSocket = ds;
      datagramSocket?.readEventsEnabled = true;
      datagramSocket?.joinMulticast(InternetAddress("224.0.0.1"));
      datagramSocket?.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? datagram = datagramSocket!.receive();
          if (datagram != null) {
            datagramSocket?.send("Joe".codeUnits, datagram.address, datagram.port);
          }
        }
      });
    });
  }

  closeServer() {
    datagramSocket = null;
  }

  refreshServers() {
    availableServers = [];
    notifyListeners();
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((dsocket) {
      datagramSocket = dsocket;
      datagramSocket?.broadcastEnabled = true;
      datagramSocket?.readEventsEnabled = true;
      datagramSocket?.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? datagram = datagramSocket?.receive();
          if (datagram != null) {
            Pair response = Pair(datagram.address, utf8.decode(datagram.data));
            availableServers.add(response);
            notifyListeners();
          }
        }
      });
      datagramSocket?.send("are you available?".codeUnits, InternetAddress("224.0.0.1"), 4041);
    });
  }
}
