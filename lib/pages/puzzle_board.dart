import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/classes/board.dart';
import 'package:flutter_puzzle_hackathon/classes/hint_algo_solve.dart';
import 'package:flutter_puzzle_hackathon/models/tile.dart';
import 'package:flutter_puzzle_hackathon/classes/zero_tile.dart';
import 'package:flutter_puzzle_hackathon/widgets/tile_widget.dart';

class PuzzleBoard extends StatefulWidget {
  final int maxRows;
  final Size size;
  const PuzzleBoard({Key? key,required this.size,required this.maxRows}) : super(key: key);

  @override
  PuzzleBoardState createState() => PuzzleBoardState();
}

class PuzzleBoardState extends State<PuzzleBoard> with TickerProviderStateMixin{
  static const double tilePadding=10;
  bool canTap = false;
  List<int> initial=[];
  List<int> goalState=[];
  List<Tile> tiles=[];
  late final AnimationController animationController;
  late Offset centerOffset;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _getPuzzle();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _getPuzzle(){
    for (int index=0;index<pow(widget.maxRows,2);index++){
      initial.add(index);
      Size sizeBox = Size((widget.size.width-(widget.maxRows+1)*tilePadding) / widget.maxRows, (widget.size.width-(widget.maxRows+1)*tilePadding) / widget.maxRows);
      Offset offsetTemp = Offset(
        index % widget.maxRows * sizeBox.width+(index%widget.maxRows+1)*tilePadding,
        index ~/ widget.maxRows * sizeBox.height+(index~/widget.maxRows+1)*tilePadding,
      );

      tiles.add(Tile(size: sizeBox, offset: offsetTemp));

    }
    centerOffset=Offset((widget.size.width-tiles.first.size.width)/2,(widget.size.height-tiles.first.size.height)/2);
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
      ZeroTile zeroTile=ZeroTile(currentTile,widget.maxRows,List.from(tiles));

      if(zeroTile.isOnLeft()||zeroTile.isOnRight()||zeroTile.isOnUp()||zeroTile.isOnBelow()){
        double x1=tiles[currentIndex].offset.dx;
        double y1=tiles[currentIndex].offset.dy;
        tiles[currentIndex].offset=tiles[zeroIndex].offset;
        tiles[zeroIndex].offset=Offset(x1,y1);
        if(Board.isSolved(tiles, widget.maxRows)){
          print('solved');
        }
      }

      setState(() {
        canTap=true;
      });
    }
  }

  void getHint()async{
    List<int> currentState=[];
    List<List<int>> goalStateIn2d=[];
    List<List<int>> currentStateIn2d=[];
    for(Tile tile in Board.orderList(List.from(tiles))){
      currentState.add(tile.value);
    }
    for(int i=0;i<widget.maxRows;i++){
      List<int> temp=goalState.sublist(i*widget.maxRows,widget.maxRows*(i+1));
      List<int> temp2=currentState.sublist(i*widget.maxRows,widget.maxRows*(i+1));
      goalStateIn2d.add(temp);
      currentStateIn2d.add(temp2);
    }
    Solve solve=Solve(widget.maxRows, currentStateIn2d, goalStateIn2d);
    List<String> result = await compute(getMoves, solve);
    print(result);
    shuffle();
  }

  void shuffle(){
    if(canTap){
      canTap=false;
      animationController.forward();
      initial.shuffle();
      _checkSolvability();
      for (int i=0;i<initial.length;i++){
        tiles[i].value=initial[i];
      }
      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
          setState(() {
            canTap=true;
          });
        }else if (status == AnimationStatus.dismissed) {
          animationController.reset();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(tilePadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.maxRows,
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
            centerOffset: centerOffset,
            changePosition: _changePosition,
            animationController: animationController,
          );
        })
      ],
    );
  }
}