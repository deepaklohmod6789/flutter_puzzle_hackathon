import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/puzzle_board.dart';
import 'package:flutter_puzzle_hackathon/testing/puzzle_board_dots.dart';

class MyGame2 extends StatefulWidget {
  const MyGame2({Key? key}) : super(key: key);

  @override
  _MyGame2State createState() => _MyGame2State();
}

class _MyGame2State extends State<MyGame2> {
  final GlobalKey<PuzzleBoardState> _puzzleKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.height*0.8,
              height: MediaQuery.of(context).size.height*0.8,
              color: Colors.black,
              child: LayoutBuilder(
                builder: (context,constraints){
                  return PuzzleBoardDots(
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
