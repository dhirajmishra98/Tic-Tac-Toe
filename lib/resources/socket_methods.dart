import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tic_tac_toe/resources/socket_client.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  //send data to server through socketio
  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit("createRoom", {
        'nickname': nickname,
      });
    }
  }

  void createRoomSuccessListener(BuildContext context) {
    _socketClient.on('createRoomSuccess', (room) {
      debugPrint(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  Socket get socketClient => _socketClient;
}
