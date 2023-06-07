import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tic_tac_toe/providers/room_data_provider.dart';
import 'package:tic_tac_toe/resources/socket_client.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/utils/snackbar.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  //EMITS : send data to server through socketio
  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit("createRoom", {
        'nickname': nickname,
      });
    }
  }

  void joinRoom(String nickname, String roomId) {
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      _socketClient.emit("joinRoom", {
        'nickname': nickname,
        'roomId': roomId,
      });
    }
  }

  //LISTENERS : get command from server and proceed
  void createRoomSuccessListener(BuildContext context) {
    _socketClient.on('createRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updataRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void joinRoomSuccessListener(BuildContext context) {
    _socketClient.on("joinRoomSuccess", (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updataRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void errorOccurredListener(BuildContext context) {
    _socketClient.on("errorOccurred", (data) {
      showSnackBar(context, data);
    });
  }

  void updatePlayersStateListener(BuildContext context) {
    _socketClient.on("updatePlayers", (playerData) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updatePlayer1(playerData[0]);
      Provider.of<RoomDataProvider>(context, listen: false)
          .updatePlayer2(playerData[1]);
    });
  }

  void updateRoomListener(BuildContext context) {
    _socketClient.on("updateRoom", (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updataRoomData(room);
    });
  }

  //FUNCTIONS : basic functions for utilities
}
