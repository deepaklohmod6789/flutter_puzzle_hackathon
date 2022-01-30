import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/classes/board.dart';
import 'package:flutter_puzzle_hackathon/classes/hint_algo_solve.dart';
import 'package:flutter_puzzle_hackathon/classes/room_services.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/models/tile.dart';
import 'package:flutter_puzzle_hackathon/classes/zero_tile.dart';
import 'package:flutter_puzzle_hackathon/widgets/empty_board_grid.dart';
import 'package:flutter_puzzle_hackathon/widgets/tile_widget.dart';

class PuzzleBoard extends StatefulWidget {
  final int maxRows;
  final double tilePadding;
  final Size size;
  RoomModel? roomModel;
  String? currentUserName;

  PuzzleBoard({
    Key? key,
    required this.size,
    required this.maxRows,
    required this.tilePadding,
    this.roomModel,
    this.currentUserName,
  }) : super(key: key);

  @override
  PuzzleBoardState createState() => PuzzleBoardState();
}

class PuzzleBoardState extends State<PuzzleBoard> with TickerProviderStateMixin{
  bool loading=true;
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

  void _getPuzzle()async{
    bool initialIsEmpty=true;
    if(widget.roomModel!=null){
      List<int> board=await RoomServices.getBoardPosition(widget.roomModel!.roomId, widget.currentUserName!,);
      initial.addAll(board);
      if(initial.isNotEmpty){
        initialIsEmpty=false;
      }
    }
    for (int index=0;index<pow(widget.maxRows,2);index++){
      if(initialIsEmpty){
        initial.add(index);
      }
      Size sizeBox = Size((widget.size.width-(widget.maxRows+1)*widget.tilePadding) / widget.maxRows, (widget.size.width-(widget.maxRows+1)*widget.tilePadding) / widget.maxRows);
      Offset offsetTemp = Offset(
        index % widget.maxRows * sizeBox.width+(index%widget.maxRows+1)*widget.tilePadding,
        index ~/ widget.maxRows * sizeBox.height+(index~/widget.maxRows+1)*widget.tilePadding,
      );

      tiles.add(Tile(size: sizeBox, offset: offsetTemp));

    }
    centerOffset=Offset((widget.size.width-tiles.first.size.width)/2,(widget.size.height-tiles.first.size.height)/2);
    initial.shuffle();
    _checkSolvability();
    if(!initialIsEmpty&&widget.roomModel!=null){
      RoomServices.saveBoardPosition(widget.roomModel!.roomId, widget.currentUserName!, initial);
    }
    for (int i=0;i<initial.length;i++){
      tiles[i].value=initial[i];
      goalState.add(i+1);
    }
    goalState.add(0);
    setState(() {
      loading=false;
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
        List<Tile> orderedTiles=Board.orderList(tiles);
        if(widget.roomModel!=null){
          saveMove(orderedTiles);
        }
        if(Board.isSolved(orderedTiles, widget.maxRows)){
          print('solved');
        }
      }

      setState(() {
        canTap=true;
      });
    }
  }

  void saveMove(List<Tile> orderedTiles){
    List<int> board=[];
    for(Tile tile in orderedTiles){
      board.add(tile.value);
    }
    RoomServices.saveBoardPosition(widget.roomModel!.roomId, widget.currentUserName!, board);
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
    return loading?const Center(child: CircularProgressIndicator(),):Stack(
      children: [
        EmptyBoardGrid(tilePadding: widget.tilePadding, maxRows: widget.maxRows),
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