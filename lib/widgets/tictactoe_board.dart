import 'package:flutter/material.dart';

class TicTacToeBoard extends StatefulWidget {
  const TicTacToeBoard({super.key});

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.7,
        maxWidth: 500,
      ),
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.white24,
            )),
            child: const Center(
              child: Text(
                'X',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 40,
                        color: Colors.blue,
                      ),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
