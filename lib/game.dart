import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/puzzle_board.dart';

class MyGame extends StatefulWidget {
  const MyGame({Key? key}) : super(key: key);

  @override
  _MyGameState createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  final GlobalKey<PuzzleBoardState> _puzzleKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.height*0.9,
              height: MediaQuery.of(context).size.height*0.9,
              color: Colors.white,
              child: LayoutBuilder(
                builder: (context,constraints){
                  return PuzzleBoard(
                    key: _puzzleKey,
                    size: constraints.biggest,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_puzzleKey.currentState!.getHint(),
        child: const Icon(Icons.help_outline_rounded),
      ),
    );
  }
}
