import 'dart:math';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/classes/board.dart';
import 'package:flutter_puzzle_hackathon/classes/leaderboard_services.dart';
import 'package:flutter_puzzle_hackathon/classes/room_services.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/main.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/models/tile.dart';
import 'package:flutter_puzzle_hackathon/classes/zero_tile.dart';
import 'package:flutter_puzzle_hackathon/pages/game.dart';
import 'package:flutter_puzzle_hackathon/widgets/empty_board_grid.dart';
import 'package:flutter_puzzle_hackathon/widgets/tile_widget.dart';
import 'package:flutter_puzzle_hackathon/widgets/win_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class PuzzleBoard extends StatefulWidget {
  final int maxRows;
  final double tilePadding;
  final Size size;
  final ValueNotifier<int> movesPlayed;
  RoomModel? roomModel;
  String? currentUserName;

  PuzzleBoard({
    Key? key,
    required this.size,
    required this.maxRows,
    required this.tilePadding,
    required this.movesPlayed,
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
      Map<String,dynamic> board=await RoomServices.getBoardPosition(widget.roomModel!.roomId,);
      initial.addAll(List.from(board['board']));
      widget.movesPlayed.value=board['moves'];
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
    if(initialIsEmpty){
      initial.shuffle();
      _checkSolvability();
    }
    if(initialIsEmpty&&widget.roomModel!=null){
      RoomServices.saveBoardPosition(widget.roomModel!.roomId, initial,widget.movesPlayed.value);
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

  void dialog(String username,int score,String content){
    int minutes = seconds ~/ 60;
    int second = seconds % 60;
    String time=minutes.toString()+':'+second.toString();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Themes.lightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: WinDialog(
          seconds: time,
          score: score,
          moves: widget.movesPlayed.value,
          image: 'https://images.unsplash.com/photo-1639628735078-ed2f038a193e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzB8fGNoYXJhY3RlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
          username: username,
          content: content,
        ),
      ),
    );
  }

  void _changePosition(int currentIndex,Tile currentTile){
    if(canTap){
      canTap=false;
      int zeroIndex=tiles.indexWhere((element) => element.value==0);
      List<Tile> orderedTiles=Board.orderList(List.from(tiles));
      ZeroTile zeroTile=ZeroTile(currentTile,widget.maxRows,List.from(orderedTiles));

      if(zeroTile.isOnLeft()||zeroTile.isOnRight()||zeroTile.isOnUp()||zeroTile.isOnBelow()){
        widget.movesPlayed.value++;
        double x1=tiles[currentIndex].offset.dx;
        double y1=tiles[currentIndex].offset.dy;
        tiles[currentIndex].offset=tiles[zeroIndex].offset;
        tiles[zeroIndex].offset=Offset(x1,y1);
        List<Tile> orderedTilesAfterPlayingMove=Board.orderList(List.from(tiles));
        if(widget.roomModel!=null){
          saveMove(orderedTilesAfterPlayingMove);
        }
        if(Board.isSolved(orderedTilesAfterPlayingMove, widget.maxRows)){
          stopWatchTimer.onExecute.add(StopWatchExecute.stop);
          int score=500 * widget.movesPlayed.value ~/ sqrt(seconds);
          dialog(currentUser.currentUserName, score, 'A significant accomplishment is an excellent opportunity to remind someone of their talent, hard effort, and deservingness. So are you; you finished the game in ${widget.movesPlayed.value} moves and $seconds seconds.',);
          if(widget.roomModel==null){
            LeaderboardServices.saveResult(
              currentUser.userId,
              currentUser.currentUserName,
              'https://images.unsplash.com/photo-1639628735078-ed2f038a193e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzB8fGNoYXJhY3RlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
              score,
              seconds,
            );
          }
          seconds=0;
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
    RoomServices.saveBoardPosition(widget.roomModel!.roomId, board,widget.movesPlayed.value);
  }

  void shuffle(){
    if(canTap){
      canTap=false;
      widget.movesPlayed.value++;
      List<Tile> orderedTiles=Board.orderList(tiles);
      if(widget.roomModel!=null){
        saveMove(orderedTiles);
      }
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