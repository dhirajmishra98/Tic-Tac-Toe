import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/providers/room_data_provider.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({super.key});

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayerBoard(
          name: roomDataProvider.player1.nickname!,
          point: roomDataProvider.player1.points!.toInt().toString(),
        ),
        const SizedBox(
          height: 5,
        ),
        PlayerBoard(
          name: roomDataProvider.player2.nickname!,
          point: roomDataProvider.player2.points!.toInt().toString(),
        ),
      ],
    );
  }
}

class PlayerBoard extends StatelessWidget {
  const PlayerBoard({super.key, required this.name, required this.point});

  final String name;
  final String point;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            point,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
