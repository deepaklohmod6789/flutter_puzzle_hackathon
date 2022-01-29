import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/pages/puzzle_board.dart';

class MyGame extends StatefulWidget {
  final RoomModel? roomModel;
  const MyGame({Key? key,this.roomModel}) : super(key: key);

  @override
  _MyGameState createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> with SingleTickerProviderStateMixin{
  final GlobalKey<PuzzleBoardState> _puzzleKey = GlobalKey();
  Matrix4 perspective = _pmat(1.0);
  static const double degrees=60.0;
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;
  late final Animation<double> rotateAnimation;
  List<Widget> boards=[];

  static Matrix4 _pmat(double pv) {
    return Matrix4(
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, pv * 0.001,
      0.0, 0.0, 0.0, 1.0,
    );
  }

  @override
  void initState() {
    animationController=AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    rotateAnimation=Tween(begin: degrees,end: 0.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));
    scaleAnimation=Tween(begin: 0.5,end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));
    getBoards();
    Future.delayed(const Duration(seconds: 1),(){
      animationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void getBoards(){
    if(widget.roomModel!=null){
      boards.add(Board(
        maxRows: widget.roomModel!.puzzleSize,
        perspective: perspective,
        animationController: animationController,
        scaleAnimation: scaleAnimation,
        rotateAnimation: rotateAnimation,
      ));
      boards.add(Board(
        maxRows: widget.roomModel!.puzzleSize,
        puzzleKey: _puzzleKey,
        perspective: perspective,
        animationController: animationController,
        scaleAnimation: scaleAnimation,
        rotateAnimation: rotateAnimation,
      ));
    } else {
      boards.add(Board(
        maxRows: 5,
        puzzleKey: _puzzleKey,
        perspective: perspective,
        animationController: animationController,
        scaleAnimation: scaleAnimation,
        rotateAnimation: rotateAnimation,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: boards,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_puzzleKey.currentState!.shuffle(),
        child: const Icon(Icons.shuffle),
      ),
    );
  }
}

class Board extends StatelessWidget {
  final int maxRows;
  final GlobalKey<PuzzleBoardState>? puzzleKey;
  final Matrix4 perspective;
  final AnimationController animationController;
  final Animation<double> scaleAnimation;
  final Animation<double> rotateAnimation;
  const Board({
    Key? key,
    this.puzzleKey,
    required this.maxRows,
    required this.animationController,
    required this.scaleAnimation,
    required this.rotateAnimation,
    required this.perspective,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animationController,
        child: SizedBox(
          width: MediaQuery.of(context).size.height*0.9,
          height: MediaQuery.of(context).size.height*0.9,
          child: LayoutBuilder(
            builder: (context,constraints){
              return PuzzleBoard(
                maxRows: maxRows,
                key: puzzleKey,
                size: constraints.biggest,
              );
            },
          ),
        ),
        builder: (context,child){
          return Transform(
            alignment: FractionalOffset.center,
            transform: perspective.scaled(scaleAnimation.value,scaleAnimation.value,scaleAnimation.value,)
              ..rotateX(math.pi - rotateAnimation.value * math.pi / 180)
              ..rotateY(-math.pi)
              ..rotateZ(-math.pi),
            child: child,
          );
        },
      ),
    );
  }
}
