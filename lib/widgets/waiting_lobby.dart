import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/providers/room_data_provider.dart';
import 'package:tic_tac_toe/responsive/responsive.dart';
import 'package:tic_tac_toe/widgets/custom_textfield.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({super.key});

  @override
  State<WaitingLobby> createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  late TextEditingController _roomIdController;

  @override
  void initState() {
    super.initState();
    _roomIdController = TextEditingController(
        text: Provider.of<RoomDataProvider>(context, listen: false)
            .roomData['_id']);
  }

  @override
  void dispose() {
    super.dispose();
    _roomIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Waiting for a player to join..."),
            const SizedBox(
              height: 20,
            ),
            const Text("GAME ID : "),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: _roomIdController,
              hintText: '',
              isReadOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
