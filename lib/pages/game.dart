import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/main.dart';
import 'package:flutter_puzzle_hackathon/models/game_arguments.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/pages/puzzle_board.dart';
import 'package:flutter_puzzle_hackathon/widgets/other_player_board.dart';

class MyGame extends StatefulWidget {
  final GameArguments? gameArguments;

  const MyGame({
    Key? key,
    this.gameArguments,
  }) : super(key: key);

  @override
  _MyGameState createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> with SingleTickerProviderStateMixin{
  final GlobalKey<PuzzleBoardState> _puzzleKey = GlobalKey();
  static const double degrees=60.0;
  static const double tilePadding=10.0;
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;
  late final Animation<double> rotateAnimation;
  List<Widget> boards=[];

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
    if(widget.gameArguments!=null){
      boards.add(Board(
        maxRows: widget.gameArguments!.roomModel.puzzleSize,
        tilePadding: tilePadding,
        isOtherPlayerBoard: true,
        roomModel: widget.gameArguments!.roomModel,
        currentUserName: widget.gameArguments!.currentUserName,
        animationController: animationController,
        scaleAnimation: scaleAnimation,
        rotateAnimation: rotateAnimation,
      ));
      boards.add(Board(
        maxRows: widget.gameArguments!.roomModel.puzzleSize,
        currentUserName: widget.gameArguments!.currentUserName,
        tilePadding: tilePadding,
        isOtherPlayerBoard: false,
        roomModel: widget.gameArguments!.roomModel,
        puzzleKey: _puzzleKey,
        animationController: animationController,
        scaleAnimation: scaleAnimation,
        rotateAnimation: rotateAnimation,
      ));
    } else {
      boards.add(Board(
        maxRows: 4,
        tilePadding: tilePadding,
        isOtherPlayerBoard: false,
        puzzleKey: _puzzleKey,
        animationController: animationController,
        scaleAnimation: scaleAnimation,
        rotateAnimation: rotateAnimation,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: ()=>_puzzleKey.currentState!.getHint(),
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
      ),
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
  final double tilePadding;
  final bool isOtherPlayerBoard;
  final GlobalKey<PuzzleBoardState>? puzzleKey;
  final AnimationController animationController;
  final Animation<double> scaleAnimation;
  final Animation<double> rotateAnimation;
  final Matrix4 perspective = _pmat(1.0);
  RoomModel? roomModel;
  String? currentUserName;
  ValueNotifier<int> movesPlayed=ValueNotifier(0);

  Board({
    Key? key,
    this.puzzleKey,
    required this.maxRows,
    required this.tilePadding,
    required this.isOtherPlayerBoard,
    required this.animationController,
    required this.scaleAnimation,
    required this.rotateAnimation,
    this.currentUserName,
    this.roomModel,
  }) : super(key: key);

  static Matrix4 _pmat(double pv) {
    return Matrix4(
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, pv * 0.001,
      0.0, 0.0, 0.0, 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: AnimatedBuilder(
            animation: animationController,
            child: SizedBox(
              width: MediaQuery.of(context).size.height*0.9,
              height: MediaQuery.of(context).size.height*0.9,
              child: LayoutBuilder(
                builder: (context,constraints){
                  return isOtherPlayerBoard?OtherPlayerBoard(
                    roomModel: roomModel!,
                    otherPlayerId: roomModel!.roomOwnerId==currentUser.userId?roomModel!.otherPlayerId:roomModel!.roomOwnerId,
                    maxRows: maxRows,
                    tilePadding: tilePadding,
                    movesPlayed: movesPlayed,
                  ):PuzzleBoard(
                    roomModel: roomModel,
                    currentUserName: currentUserName,
                    tilePadding: tilePadding,
                    maxRows: maxRows,
                    key: puzzleKey,
                    size: constraints.biggest,
                    movesPlayed: movesPlayed,
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
        ),
        const SizedBox(height: 10,),
        ValueListenableBuilder(
          valueListenable: movesPlayed,
          builder: (context,child,value) {
            return Text("Moves played:"+movesPlayed.value.toString());
          }
        ),
      ],
    );
  }
}
