import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/classes/board.dart';
import 'package:flutter_puzzle_hackathon/classes/hint_algo_solve.dart';
import 'package:flutter_puzzle_hackathon/classes/tile.dart';
import 'package:flutter_puzzle_hackathon/classes/zero_tile.dart';
import 'package:flutter_puzzle_hackathon/widgets/tile_widget.dart';

class PuzzleBoard extends StatefulWidget {
  final Size size;
  const PuzzleBoard({Key? key,required this.size}) : super(key: key);

  @override
  PuzzleBoardState createState() => PuzzleBoardState();
}

class PuzzleBoardState extends State<PuzzleBoard> with SingleTickerProviderStateMixin{
  static const int maxRows=4;
  static const double tilePadding=10;
  bool canTap = false;
  List<int> initial=[];
  List<int> goalState=[];
  List<Tile> tiles=[];
  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _getPuzzle();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _getPuzzle(){
    for (int index=0;index<pow(maxRows,2);index++){
      initial.add(index);
      Size sizeBox = Size((widget.size.width-(maxRows+1)*tilePadding) / maxRows, (widget.size.width-(maxRows+1)*tilePadding) / maxRows);
      Offset offsetTemp = Offset(
        index % maxRows * sizeBox.width+(index%maxRows+1)*tilePadding,
        index ~/ maxRows * sizeBox.height+(index~/maxRows+1)*tilePadding,
      );

      tiles.add(Tile(size: sizeBox, offset: offsetTemp));

    }
    initial.shuffle();
    _checkSolvability();
    for (int i=0;i<initial.length;i++){
      tiles[i].value=initial[i];
      goalState.add(i+1);
    }
    goalState.add(0);
    setState(() {
      canTap=true;
    });
  }

  void _checkSolvability(){
    bool puzzleIsUnSolveable=Board.haveOddInverts(initial);
    if(puzzleIsUnSolveable){
      initial.shuffle();
      _checkSolvability();
    }
  }

  void _changePosition(int currentIndex,Tile currentTile){
    if(canTap){
      canTap=false;
      int zeroIndex=tiles.indexWhere((element) => element.value==0);
      ZeroTile zeroTile=ZeroTile(currentTile,maxRows,List.from(tiles));
      bool movePlayed=false;

      if(zeroTile.isOnLeft()||zeroTile.isOnRight()||zeroTile.isOnUp()||zeroTile.isOnBelow()){
        movePlayed=true;
        double x1=tiles[currentIndex].offset.dx;
        double y1=tiles[currentIndex].offset.dy;
        tiles[currentIndex].offset=tiles[zeroIndex].offset;
        tiles[zeroIndex].offset=Offset(x1,y1);
      }

      setState(() {
        canTap=true;
      });
      if(movePlayed){
        if(Board.isSolved(tiles, maxRows)){
          print('solved');
        }
      }
    }
  }

  void getHint()async{
    List<int> currentState=[];
    List<List<int>> goalStateIn2d=[];
    List<List<int>> currentStateIn2d=[];
    for(Tile tile in Board.orderList(List.from(tiles))){
      currentState.add(tile.value);
    }
    for(int i=0;i<maxRows;i++){
      List<int> temp=goalState.sublist(i*maxRows,maxRows*(i+1));
      List<int> temp2=currentState.sublist(i*maxRows,maxRows*(i+1));
      goalStateIn2d.add(temp);
      currentStateIn2d.add(temp2);
    }
    Solve solve=Solve(maxRows, currentStateIn2d, goalStateIn2d);
    final result = await compute(getMoves, solve);
    print(result);
  }

  void shuffle(){
    canTap=false;
    animationController.forward();
    initial.shuffle();
    _checkSolvability();
    for (int i=0;i<initial.length;i++){
      tiles[i].value=initial[i];
    }
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
        setState(() {
          canTap=true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(tilePadding),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: maxRows,
            mainAxisSpacing: tilePadding,
            crossAxisSpacing: tilePadding,
          ),
          itemCount: tiles.length,
          itemBuilder: (context,index){
            return Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: -4,
                color: Colors.black12,
                lightSource: LightSource.topRight,
              ),
            );
          },
        ),
        ...List.generate(tiles.length, (index){
          return TileWidget(
            index: index,
            tile: tiles[index],
            changePosition: _changePosition,
            animationController: animationController,
          );
        })
      ],
    );
  }
}